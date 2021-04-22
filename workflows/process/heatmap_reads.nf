process heatmap_reads {
    publishDir "${params.output}/stats/plots/", mode: 'copy', pattern: "*.svg"
    label 'R_plot'
    input:
        path(read_until)
    output:
        path("*.svg")
    script:
        """
        heatmap_reads.R
        """
}