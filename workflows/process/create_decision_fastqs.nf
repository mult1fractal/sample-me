process create_decision_fastqs {
    publishDir "${params.output}/fastqs_separated/", mode: 'copy', pattern: "*.fastq.gz"
    label 'seqkit'
    input:
        tuple val(name), path(fastq)
        tuple val(decision), path(decision_file)
    output:
        tuple val(name), path("*.fastq.gz")
    script:
        """
        for i in *.txt ; do
            decision=\$(echo "\$i" | cut -d "_" -f1 )
            seqkit grep --pattern-file \$i ${fastq} >> "\$decision"_${name}.fastq
            gzip "\$decision"_${name}.fastq
        done
        """
}
// https://bioinformatics.cvr.ac.uk/essential-awk-commands-for-next-generation-sequence-analysis/


// for i in *.txt ; do
//             decision=$(echo "$i" | cut -d "_" -f1 )
//             echo "$decision"
//         done