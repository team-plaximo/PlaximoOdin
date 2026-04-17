# 🧠 Master Architecture Report: Local Claude & PlaximoOdin Deep-Dive

This document explains the technical "magic" that allows a mid-range laptop (RTX 4070, 32GB RAM) to run the **Qwen3.5-35B-A3B** model with full tool-calling support in **Claude Code**.

---

## 1. The Interception Layer: "Silent Routing"
The core of the integration isn't a complex proxy service, but a clever use of environment variables that tricks the **Claude Code CLI** into talking to your local server.

- **\`ANTHROPIC_BASE_URL\`**: By exporting this as \`http://localhost:8080\`, every request that Claude Code *thinks* it's sending to San Francisco (Anthropic's servers) is actually captured by your local \`llama-server\`.
- **API Translation**: \`llama-server\` provides an OpenAI-compatible API. Fortunately, Claude Code’s underlying client is flexible enough to accept these responses when the base URL is redirected, as long as the model name and format align.
- **The Identity Hack**: You pass \`--model Qwen3.5-35B-A3B-Q4_K_M.gguf\` to Claude Code. It passes this string through to the server, which recognizes the file and serves it.

---

## 2. The Intelligence Core: Qwen 3.5 MoE (Mixture of Experts)
How can a "35 Billion" parameter model run at ~20-30 tokens/sec on a laptop?

- **"35B-A3B" Explained**: This model has 35 billion total parameters, but it is an **MoE** (Mixture of Experts).
- **The Gating Network**: Every time the model processes a token, a "Router" (the Gating Network) activates only a subset of "experts" (neurons). 
- **Active Parameters (~3B)**: Only about 3 billion parameters are actually calculated for any given token. This is why it has the **intelligence of a 30B+ model** but the **speed of a 3B model**.
- **The "Goldilocks" Choice**: Qwen 3.5 is currently the state-of-the-art for this size/active-count ratio, making it smarter than Llama-3-8B while being faster than Llama-3-70B.

---

## 3. Memory & Performance Engineering
We are pushing the limits of **32GB RAM** and **8GB VRAM**.

### A. Quantization (Q4_K_M)
We use a 4-bit "K-Quants" method. This reduces the model weight from ~70GB (uncompressed) to ~21GB. This allows the model to reside comfortably in your 32GB system RAM.

### B. Hybrid Offloading (-ngl 8)
- **VRAM Constraint**: Your RTX 4070 has only 8GB. A full GPU offload would require 24GB+ for this model.
- **Strategic Load**: We offload exactly **8 layers** to the GPU. This gives the GPU enough work to stay busy without overflowing the 8GB buffer (which must also host Windows/Linux UI and the KV Cache).

### C. KV Cache Compression (\`q4_0\`)
- **Standard Cache**: Takes massive amounts of RAM as the conversation grows.
- **Quantized Cache**: By setting \`--cache-type-k q4_0\` and \`--cache-type-v q4_0\`, we compress the "memory" of the conversation by 75%, allowing you to reach a **32k context window** without OOM (Out of Memory) errors.

### D. System Flags
- **\`--mlock\`**: This "locks" the model in RAM, preventing the OS from swapping it to the slow SSD, which would cause "stuttering" during chat.
- **\`--n-cpu-moe 36\`**: (In the toolcall profile) This optimizes thread allocation specifically for MoE routing, ensuring experts are activated across all CPU cores synchronously.

---

## 4. The Logic Patch: Patched Jinja Template
This was the "missing link" solved in the last chat.

### The Problem: The "Double-JSON" Loop
Claude Code sends tool parameters as a JSON object: \`{"loc": "Berlin"}\`.
Standard Qwen templates expect a **stringified** JSON object: \`"{ \"loc\": \"Berlin\" }"\`.
When the server got an object where it expected a string, it failed to parse or double-escaped it, leading to a **500 Internal Server Error**.

### The Solution: \`qwen35_fixed.jinja\`
The patched template includes custom logic:
\`\`\`jinja
{% if arguments is string %}
    {{ arguments }}
{% else %}
    {{ arguments | tojson }}
{% endif %}
\`\`\`
- **How it works**: It checks the data type. If it's a string, it passes it through. If it's an object, it converts it to JSON safely.
- **XML Injection**: It also wraps these in \`<tool_call>\` tags, which the model was specifically trained to prioritize for tool-calling logic.

---

## 5. Summary Flow
1.  **User Input** -> Claude CLI (Local environment)
2.  **Request** -> Redirected to \`localhost:8080\` (Interception)
3.  **llama-server** -> Uses \`qwen35_fixed.jinja\` to format the prompt.
4.  **CPU/GPU** -> MoE Gating activates 3B params (GGUF Q4_K_M weights).
5.  **Output** -> XML Tag \`<tool_call>\` generated.
6.  **Claude CLI** -> Parses XML, executes tool (e.g., \`ls\` or \`grep\`).
7.  **Loop** -> Tool result sent back to server via \`<tool_response>\`.

> [!IMPORTANT]
> This setup is "State-of-the-Art" for local development. You are getting **Cloud-level tool-calling intelligence** on a **consumer laptop** with **zero latency** and **total privacy**.
