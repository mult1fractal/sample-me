process pycoqc {
        label 'pycoqc'  
        publishDir "${params.output}/sequencing_qc/", mode: 'copy', pattern: "${name}_sequencing_performance.html"
    input:
        tuple val(name), path(txt_files)
    output:
        tuple val(name), path("${name}_sequencing_performance.html") 
    script:
    // if (params.single)
        """
        pycoQC -f ${txt_files} -o ${name}_sequencing_performance.html 
        """
    // else
    //     """
    //     pycoQC -f sequencing_summary.txt -b barcoding_summary.txt -o ${name}_sequencing_performance.html         
    //     """
}