process boxplot {
    publishDir "${params.output}/stats/plots/", mode: 'copy', pattern: "*.svg"
    label 'R_plot'
    input:
        path(readcount)
    output:
        path("*.svg")
    script:
        """
        boxplot.R
        """
}