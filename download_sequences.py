import requests
import argparse

parser = argparse.ArgumentParser()

parser.add_argument("path")

args = parser.parse_args()

target_dir = args.path

#target_dir =' /Users/ads/Desktop/gp_projekt/list_proteomes2.txt'
with open(target_dir, 'r') as f:
    proteomes = f.read().splitlines()

for proteome in proteomes:
    url = 'https://rest.uniprot.org/uniprotkb/stream?format=fasta&query=%28%28proteome%3A'+proteome+'%29%29'
    with requests.get(url, stream=True) as request:
        request.raise_for_status()
        with open('all.fasta', "ab") as f:
            for chunk in request.iter_content(chunk_size=2**20):
                f.write(chunk)
