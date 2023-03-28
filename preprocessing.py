from tempfile import mkstemp
from os import fdopen
import shutil
import os
import argparse


parser = argparse.ArgumentParser()

parser.add_argument("path")

args = parser.parse_args()

target_dir = args.path

os.mkdir("families")
os.mkdir("full_clusters")

def replace(file_path, pattern, subst):
    #Create temp file
    fh, abs_path = mkstemp()
    with fdopen(fh,'w') as new_file:
        with open(file_path) as old_file:
            for line in old_file:
                new_file.write(line.replace(pattern, subst))

def substring_after(s, delim):
    return s.partition(delim)[2]

def substring_before(s, delim):
    return s.partition(delim)[0]

def substring_after_name(s, delim):
    return s.partition(delim)[1:3]


with open(target_dir,"rt") as search_file:
    with open("rename.fasta",'wt') as out_file:

        i=0
        for line in search_file:
            if ">" in line: 
                if ">tr" in line:
                    s =substring_after(line,'OS=')
                    p = substring_before(s,'OX').split()[:2]
                    new_name= ' '.join(p)
                    out_file.write((">"+line.replace(line, new_name)+"\n"))
                else: 
                    i+=1
                    clust = ">Cluster" + str(i)
                    out_file.write((line.replace(line, clust)+"\n"))
            
            else:
                out_file.write(line+"\n")

with open("rename.fasta", 'rt') as cluster_file:
    for line in cluster_file:
        if "Cluster" in line: 
            name_file = "families/" + ''.join(substring_after_name(line,'Cluster')).strip() + ".fasta"

        with open(name_file, "a+") as out_file:
            out_file.write(line)
        out_file.close()

i=0
j=0
index_of_clusers = []
with open("rename.fasta", 'rt') as cluster_file:
    for line in cluster_file:
        if "Cluster" in line: 
            i+=1
            cluster = []
        if ">" in line:
           cluster.append(substring_after(line,">"))
           if len(set(cluster)) == len(cluster):
                if len(cluster)==24:
                    index_of_clusers.append(i)
                    j+=1
                    #print(cluster[1:])
                    

# path to source directory
src_dir = 'families'
 
# path to destination directory
dest_dir = 'full_clusters'

names_of_files = []

for i in index_of_clusers:
    names_of_files.append("Cluster"+str(i)+".fasta")


# iterating over all the files in
# the source directory
for fname in names_of_files:
     
    # copying the files to the
    # destination directory
        shutil.copy2(os.path.join(src_dir,fname), dest_dir)
        #print(fname)

