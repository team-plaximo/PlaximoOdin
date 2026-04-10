#!/usr/bin/env python3
"""
PlaximoOdin Python Client
OpenAI-kompatibler Client für llama-server

Usage:
    from plaximo_client import PlaximoClient
    
    client = PlaximoClient("http://192.168.10.2:8080")
    
    # Chat
    response = client.chat("Hallo!", system="Du bist ein hilfreicher Assistent.")
    
    # Completion
    text = client.complete("Die Hauptstadt von Frankreich ist")
    
    # Embeddings
    emb = client.embed("Hallo Welt")
"""

import json
import urllib.request
import urllib.error
from typing import Optional


class PlaximoClient:
    def __init__(self, base_url: str = "http://192.168.10.2:8080"):
        self.base_url = base_url.rstrip("/")
        self.api_base = f"{self.base_url}/v1"
    
    def _request(self, endpoint: str, payload: dict) -> dict:
        """Macht einen API-Request"""
        url = f"{self.api_base}{endpoint}"
        data = json.dumps(payload).encode("utf-8")
        req = urllib.request.Request(
            url,
            data=data,
            headers={"Content-Type": "application/json"}
        )
        
        with urllib.request.urlopen(req, timeout=300) as response:
            return json.loads(response.read().decode("utf-8"))
    
    def chat(
        self,
        message: str,
        system: Optional[str] = None,
        temperature: float = 0.7,
        max_tokens: int = 4096
    ) -> str:
        """Chat-Completion"""
        messages = []
        if system:
            messages.append({"role": "system", "content": system})
        messages.append({"role": "user", "content": message})
        
        payload = {
            "messages": messages,
            "temperature": temperature,
            "max_tokens": max_tokens,
            "stream": False
        }
        
        response = self._request("/chat/completions", payload)
        return response["choices"][0]["message"]["content"]
    
    def complete(
        self,
        prompt: str,
        max_tokens: int = 256,
        temperature: float = 0.7,
        stop: Optional[list] = None
    ) -> str:
        """Text-Completion"""
        payload = {
            "prompt": prompt,
            "max_tokens": max_tokens,
            "temperature": temperature,
            "stream": False
        }
        if stop:
            payload["stop"] = stop
        
        response = self._request("/completions", payload)
        return response["choices"][0]["text"]
    
    def embed(self, text: str) -> list:
        """Embeddings erstellen"""
        payload = {"input": text}
        response = self._request("/embeddings", payload)
        return response["data"][0]["embedding"]
    
    def embed_batch(self, texts: list) -> list:
        """Batch Embeddings erstellen"""
        payload = {"input": texts}
        response = self._request("/embeddings", payload)
        return [item["embedding"] for item in response["data"]]
    
    def models(self) -> list:
        """Verfügbare Modelle"""
        response = self._request("/models", {})
        return [m["id"] for m in response.get("data", [])]
    
    def health(self) -> bool:
        """Server-Status prüfen"""
        try:
            url = f"{self.base_url}/health"
            with urllib.request.urlopen(url, timeout=5):
                return True
        except:
            return False


if __name__ == "__main__":
    client = PlaximoClient()
    
    print("Testing connection...")
    if client.health():
        print("✓ Server ist erreichbar")
        print(f"✓ Verfügbare Modelle: {client.models()}")
    else:
        print("✗ Server nicht erreichbar")
    
    # Demo
    print("\nDemo Chat:")
    response = client.chat("Sag Hallo in einem Satz.")
    print(f"Antwort: {response}")
