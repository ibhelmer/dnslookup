#!/usr/bin/env python3
# -----------------------------------------------------------
# DNS Lookup Tool
# Forfatter: Ib Helmer Nielsen / UCN
#
# Beskrivelse:
#   Dette program udfører et DNS-opslag på et hostnavn og
#   viser IPv4-, IPv6- og reverse DNS-information.
#
# Syntaks:
#   python3 dns_lookup.py <hostnavn>
#
# Eksempel:
#   python3 dns_lookup.py google.com
#
# Programmet bruger kun Python's standardbibliotek.
# -----------------------------------------------------------

import socket
import argparse


def dns_lookup(hostname: str) -> None:
    print(f"DNS-opslag for: {hostname}")
    print("-" * 50)

    try:
        addrinfo = socket.getaddrinfo(hostname, None)
    except socket.gaierror as e:
        print(f"Fejl ved DNS-opslag: {e}")
        return

    ipv4_addresses = set()
    ipv6_addresses = set()

    for family, _, _, _, sockaddr in addrinfo:
        ip = sockaddr[0]
        if family == socket.AF_INET:
            ipv4_addresses.add(ip)
        elif family == socket.AF_INET6:
            ipv6_addresses.add(ip)
    canonical_name = socket.getfqdn(hostname)
    print(f"Kanonavn (FQDN): {canonical_name}\n")

    print("IPv4-adresser:")
    print("\n".join(f"  - {ip}" for ip in sorted(ipv4_addresses))) if ipv4_addresses else print("  Ingen")

    print("\nIPv6-adresser:")
    print("\n".join(f"  - {ip}" for ip in sorted(ipv6_addresses))) if ipv6_addresses else print("  Ingen")

    print("\n" + "-" * 50)

    # Reverse lookup på første fundne IP
    all_ips = list(ipv4_addresses) + list(ipv6_addresses)
    if all_ips:
        ip = all_ips[0]
        print(f"Reverse DNS-opslag for {ip}:")
        try:
            host, aliases, _ = socket.gethostbyaddr(ip)
            print(f"  Hostnavn : {host}")
            if aliases:
                print("  Aliasser :")
                for a in aliases:
                    print(f"    - {a}")
        except Exception as e:
            print(f"  Kunne ikke lave reverse lookup: {e}")

def main():
    parser = argparse.ArgumentParser(description="Lav et DNS-opslag på et hostnavn.")
    parser.add_argument("hostname", help="Hostnavnet der skal slåes op, fx google.com")
    args = parser.parse_args()

    dns_lookup(args.hostname)

if __name__ == "__main__":
    main()

