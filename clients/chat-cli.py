#!/usr/bin/env python3
"""
PlaximoOdin Client - Einfacher Chat-Client für llama-server
Verwendung: python3 chat-cli.py [--host 192.168.10.2] [--port 8080]
"""

import argparse
import json
import sys
import urllib.request
import urllib.error


def send_request(host: str, port: int, messages: list) -> dict:
    """Sendet Chat-Request an llama-server"""
    url = f"http://{host}:{port}/v1/chat/completions"
    
    payload = {
        "messages": messages,
        "stream": False,
        "max_tokens": 2048,
        "temperature": 0.7,
        "top_p": 0.9
    }
    
    data = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(
        url,
        data=data,
        headers={"Content-Type": "application/json"}
    )
    
    try:
        with urllib.request.urlopen(req, timeout=300) as response:
            return json.loads(response.read().decode("utf-8"))
    except urllib.error.URLError as e:
        print(f"Fehler: {e}")
        sys.exit(1)


def main():
    parser = argparse.ArgumentParser(description="PlaximoOdin Chat Client")
    parser.add_argument("--host", default="192.168.10.2", help="Server IP")
    parser.add_argument("--port", type=int, default=8080, help="Server Port")
    args = parser.parse_args()
    
    print("=" * 50)
    print("PlaximoOdin Chat Client")
    print(f"Server: http://{args.host}:{args.port}")
    print("Tippe 'exit' zum Beenden")
    print("=" * 50)
    
    messages = []
    
    while True:
        try:
            user_input = input("\nDu: ").strip()
        except (EOFError, KeyboardInterrupt):
            print("\nBye!")
            break
        
        if not user_input:
            continue
        
        if user_input.lower() in ["exit", "quit", "q"]:
            print("Bye!")
            break
        
        messages.append({"role": "user", "content": user_input})
        
        print("\nOdin denkt...")
        try:
            response = send_request(args.host, args.port, messages)
            answer = response["choices"][0]["message"]["content"]
            print(f"\nOdin: {answer}")
            messages.append({"role": "assistant", "content": answer})
        except Exception as e:
            print(f"Fehler: {e}")


if __name__ == "__main__":
    main()
