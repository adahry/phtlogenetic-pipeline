rule get_proteomes:
    input: 
        lista = "list_proteomes.txt"
    output: 
        "all.fasta"
    shell: 
        "python3 download_sequences.py {input}"

rule cluster:
    input: 
        "all.fasta"
    output: 
        "clusterRes_all_seqs.fasta" 
    shell: 
        "mmseqs easy-cluster {input} clusterRes tmp --min-seq-id 0.4 -c 0.8 --cov-mode 1"

rule preprocess:
    input:
        "clusterRes_all_seqs.fasta" 
    output: 
        directory('families'), directory('full_clusters')
    shell:
        "python3 preprocessing.py {input}"

rule make_trees:
    input:
        directory('full_clusters')
    output:
        "trees.nwk"
    shell:
        "Rscript makeNJ.R {input}"

rule make_trees_paralogs:
    input:
        directory('families')
    output:
        "paralogi.nwk"
    shell:
        "Rscript paralogi.R {input}"


rule super_tree:
    input:
        'trees.nwk'
    output:
        'fasturec_output.txt'
    shell:
        'fasturec -G {input} -Z'

rule supertree_filter: 
    input:
        "fasturec_output.txt"
    output: 
        "supertree.txt"
    shell: 
        "python3 fasturec_filter.py {input}"

rule supertrees_paralogs:
    input:
        "paralogi.nwk"
    output:
        "final_paralogi.nwk"
    shell:
        'fasturec -G {input} -Z'

rule supertree_paralogs_filter: 
    input:
        "final_paralogi.nwk"
    output: 
        "paralog.nwk"
    shell: 
        "python3 fasturec_filter.py {input}"


rule consensus_tree:
    input:
        'trees.nwk'
    output:
        'consensus_tree.nwk'
    shell:
        "Rscript consensus.R {input}"


rule bootstrap:
    input:
        directory('full_clusters')
    output:
        "afterbootstrap.nwk"
    shell:
        "Rscript bootstrap.R {input}"

rule conensus_bootstrap:
    input:
        "afterbootstrap.nwk"
    output:
        "consensus_bootstrap.nwk"
    shell:
        "Rscript consensus.R {input}"

rule supertree_bootstrap:
    input:
        'afterbootstrap.nwk'
    output:
        'supertree_b.txt'
    shell:
        'fasturec -G {input} -Z'

rule supertree_bootstrap_filter:
    input:
        "supertree_b.txt"
    output:
        "supertree_bootstrap.txt"
    shell:
        "python3 fasturec_filter.py {input}"

rule final_report:
    input: 
        consensus  = "consensus_tree.nwk", 
        consensusb = "consensus_bootstrap.nwk", 
        supertree = "supertree.txt", 
        supertreeb = "supertree_bootstrap.txt"
    output:
        result1 = "consensus.pdf",
        result2 = "consensusbootstrap.pdf",
        result3 = "supertree.pdf",
        result4 = "supertreebootstrap.pdf",
        result5 = "paralogs.pdf"
    shell:
        "Rscript report.R {input.consensus} {input.consensusb} {input.supertree} {input.supertreeb}"



