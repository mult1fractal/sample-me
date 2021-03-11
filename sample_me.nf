#!/usr/bin/env nextflow
nextflow.enable.dsl=2

/*
* 
* Author: KEK
*/

/************************** 
* HELP messages & checks
**************************/

/* 
Nextflow version check  
Format is this: XX.YY.ZZ  (e.g. 20.07.1)
change below
*/

XX = "20"
YY = "10"
ZZ = "0"

if ( nextflow.version.toString().tokenize('.')[0].toInteger() < XX.toInteger() ) {
println "\033[0;33mporeCov requires at least Nextflow version " + XX + "." + YY + "." + ZZ + " -- You are using version $nextflow.version\u001B[0m"
exit 1
}
else if ( nextflow.version.toString().tokenize('.')[1].toInteger() == XX.toInteger() && nextflow.version.toString().tokenize('.')[1].toInteger() < YY.toInteger() ) {
println "\033[0;33mporeCov requires at least Nextflow version " + XX + "." + YY + "." + ZZ + " -- You are using version $nextflow.version\u001B[0m"
exit 1
}



// profile helps
    if ( workflow.profile == 'standard' ) { exit 1, "NO EXECUTION PROFILE SELECTED, use e.g. [-profile local,docker]" }
    if (params.profile) { exit 1, "--profile is WRONG use -profile" }
    if (
        workflow.profile.contains('singularity') ||
        workflow.profile.contains('nanozoo') ||
        workflow.profile.contains('ukj_cloud') ||
        workflow.profile.contains('docker')
        ) { "engine selected" }
    else { println "No engine selected:  -profile EXECUTER,ENGINE" 
           println "using native installations" }
    if (
        workflow.profile.contains('nanozoo') ||
        workflow.profile.contains('ukj_cloud') ||
        workflow.profile.contains('local')
        ) { "executer selected" }
    else { exit 1, "No executer selected:  -profile EXECUTER,ENGINE" }

    if (workflow.profile.contains('local')) {
        println "\033[2m Using $params.cores/$params.max_cores CPU threads [--max_cores]\u001B[0m"
        println " "
    }
    if ( workflow.profile.contains('singularity') ) {
        println ""
        println "\033[0;33mWARNING: Singularity image building sometimes fails!"
        println "Multiple resumes (-resume) and --max_cores 1 --cores 1 for local execution might help.\033[0m\n"
    }

// params help
if (!workflow.profile.contains('test_fastq') && !workflow.profile.contains('test_fast5') && !workflow.profile.contains('test_fasta')) {
    if (!params.fasta &&  !params.fast5 &&  !params.fastq &&  !params.fastq_pass ) {
        exit 1, "input missing, use [--fasta] [--fastq] [--fastq_pass] or [--fast5]"}
    if ((params.fasta && ( params.fastq || params.fast5 )) || ( params.fastq && params.fast5 )) {
        exit 1, "To many inputs: please us either: [--fasta], [--fastq] or [--dir]"} 
if ( (params.cores.toInteger() > params.max_cores.toInteger()) && workflow.profile.contains('local')) {
        exit 1, "More cores (--cores $params.cores) specified than available (--max_cores $params.max_cores)" }
}
/************************** 
* INPUTs
**************************/

// fastq raw input direct from basecalling
    if (params.fastq_pass && params.list && !workflow.profile.contains('test_fastq')) { 
        fastq_dir_ch = Channel
        .fromPath( params.fastq_pass, checkIfExists: true )
        .splitCsv()
        .map { row -> ["${row[0]}", file("${row[1]}", checkIfExists: true, type: 'dir')] }
    }
    else if (params.fastq_pass && !workflow.profile.contains('test_fastq')) { 
        fastq_dir_ch = Channel
        .fromPath( params.fastq_pass, checkIfExists: true, type: 'dir')
        .map { file -> tuple(file.simpleName, file) }
    }


// samples input 
    if (params.samples) { samples_input_ch = Channel
        .fromPath( params.samples, checkIfExists: true)
        .splitCsv(header: true, sep: ',')
        .map { row -> tuple ("barcode${row.barcode[-2..-1]}", "${row._id}")}
        .view()
    }
    // extended input
    // if (params.samples && params.extended) { 
    //     extended_input_ch = Channel.fromPath( params.samples, checkIfExists: true)
    //     .splitCsv(header: true, sep: ',')
    //     .collectFile() {
    //                 row -> [ "extended.csv", row.'_id' + ',' + row.'Submitting_Lab' + ',' + row.'Isolation_Date' + ',' + 
    //                 row.'Seq_Reason' + ',' + row.'Sample_Type' + '\n']
    //                 }
    // }
    else { extended_input_ch = Channel.from( ['deactivated', 'deactivated'] ) }


/************************** 
* MODULES
**************************/

// include { get_fast5 } from './modules/get_fast5_test_data.nf'
// include { get_nanopore_fastq } from './modules/get_fastq_test_data.nf'
// include { get_fasta } from './modules/get_fasta_test_data.nf'
// include { align_to_reference } from './modules/align_to_reference.nf'
// include { split_fasta } from './modules/split_fasta.nf'

/************************** 
* Workflows
**************************/

// include { artic_ncov_wf } from './workflows/artic_nanopore_nCov19.nf'
// include { basecalling_wf } from './workflows/basecalling.nf'
include { collect_fastq_wf } from './workflows/collect_fastq.nf'
include { emit_fastq_wf } from './workflows/emit_fastq.nf'
// include { create_json_entries_wf } from './workflows/create_json_entries.nf'
// include { create_summary_report_wf } from './workflows/create_summary_report.nf'
// include { determine_lineage_wf } from './workflows/determine_lineage.nf'
// include { determine_mutations_wf } from './workflows/determine_mutations.nf'
// include { genome_quality_wf } from './workflows/genome_quality.nf'
// include { read_classification_wf } from './workflows/read_classification'
// include { read_qc_wf } from './workflows/read_qc.nf'
// include { rki_report_wf } from './workflows/provide_rki.nf'

/************************** 
* MAIN WORKFLOW
**************************/

workflow {

        // fastq input via dir and or files
        //if ( (params.fastq || params.fastq_pass) || workflow.profile.contains('test_fastq')) { 
            if (params.fastq_pass && !params.fastq) { fastq_input_raw_ch = collect_fastq_wf(fastq_dir_ch) }
            if (!params.fastq_pass && params.fastq) { fastq_input_raw_ch = fastq_file_ch }

            // raname barcodes bases on --samples input.csv
                if (params.samples) { fastq_input_ch = fastq_input_raw_ch.join(samples_input_ch).map { it -> tuple(it[2],it[1])}.view() }
                else if (!params.samples) { fastq_input_ch = fastq_input_raw_ch }
                
            emit_fastq_wf(fastq_input_ch)
            // read_qc_wf(fastq_input_ch)
            // read_classification_wf(fastq_input_ch)
           }   // fasta_input_ch = artic_ncov_wf(fastq_input_ch)[0]
        

  
/*************  
* --help
*************/
def helpMSG() {
    c_green = "\033[0;32m";
    c_reset = "\033[0m";
    c_yellow = "\033[0;33m";
    c_blue = "\033[0;34m";
    c_dim = "\033[2m";
    log.info """
    ____________________________________________________________________________________________
    
    ${c_green}poreCov${c_reset} | A Nextflow SARS-CoV-2 (nCov19) workflow for nanopore data
    
    ${c_yellow}Usage examples:${c_reset}
    nextflow run replikation/poreCov --fastq 'sample_01.fasta.gz' --cores 14 -profile local,singularity

    ${c_yellow}Inputs (choose one):${c_reset}
    --fast5           one fast5 dir of a nanopore run containing multiple samples (barcoded);
                    to skip demultiplexing (no barcodes) add the flag [--single]
                    ${c_dim}[Basecalling + Genome reconstruction + Lineage + Reports]${c_reset}

    --fastq         one fastq or fastq.gz file per sample or
                    multiple file-samples: --fastq 'sample_*.fasta.gz'
                    ${c_dim}[Genome reconstruction + Lineage + Reports]${c_reset}

    --fastq_pass    the fastq_pass dir from the (guppy) bascalling
                    --fastq_pass 'fastq_pass/'
                    to skip demultiplexing (no barcodes) add the flag [--single]
                    ${c_dim}[Genome reconstruction + Lineage + Reports]${c_reset}

    --fasta         direct input of genomes - supports multi-fasta file(s)
                    ${c_dim}[Lineage + Reports]${c_reset}

    ${c_yellow}Workflow control ${c_reset}
    --rki           activates RKI style summary for DESH upload
    --samples       .csv input (header: Status,_id), renames barcodes (Status) by name (_id), e.g.:
                    Status,_id,
                    barcode01,sample2011XY
                    BC02,thirdsample_run
    --extended      poreCov utilizes from --samples these additional headers:
                    Submitting_Lab,Isolation_Date,Seq_Reason,Sample_Type

    ${c_yellow}Parameters - Basecalling${c_reset}
    --localguppy    use a native installation of guppy instead of a gpu-docker or gpu_singularity 
    --guppy_cpu     use cpus instead of gpus for basecalling
    --one_end       removes the recommended "--require_barcodes_both_ends" from guppy demultiplexing
                    try this if to many barcodes are unclassified (beware - results might not be trustworthy)

    ${c_yellow}Parameters - nCov genome reconstruction${c_reset}
    --primerV       artic-ncov2019 primer_schemes [default: ${params.primerV}]
                        Supported: V1, V2, V3, V1200
    --minLength     min length filter raw reads [default: ${params.minLength}]
    --maxLength     max length filter raw reads [default: ${params.maxLength}]
    --medaka_model  medaka model for the artic workflow [default: ${params.medaka_model}]
    --guppy_model   guppy basecalling modell [default: ${params.guppy_model}]

    ${c_yellow}Parameters - Genome quality control${c_reset}
    --reference_for_qc      reference FASTA for consensus qc (optional, wuhan is provided by default)
    --seq_threshold         global pairwise ACGT sequence identity threshold [default: ${params.seq_threshold}] 
    --n_threshold           consensus sequence N threshold [default: ${params.n_threshold}] 

    ${c_yellow}Options:${c_reset}
    --cores         amount of cores for a process (local use) [default: $params.cores]
    --max_cores     max amount of cores for poreCov to use (local use) [default: $params.max_cores]
    --memory        available memory [default: $params.memory]
    --output        name of the result folder [default: $params.output]
    --cachedir      defines the path where singularity images are cached
                    [default: $params.cachedir]
    --krakendb      provide a .tar.gz kraken database [default: auto downloads one]

    ${c_yellow}Execution/Engine profiles:${c_reset}
    poreCov supports profiles to run via different ${c_green}Executers${c_reset} and ${c_blue}Engines${c_reset} 
    examples:
     -profile ${c_green}local${c_reset},${c_blue}docker${c_reset}
     -profile ${c_yellow}test_fastq${c_reset},${c_green}slurm${c_reset},${c_blue}singularity${c_reset}

      ${c_green}Executer${c_reset} (choose one):
       local
       slurm
      ${c_blue}Engines${c_reset} (choose one):
       docker
       singularity
      ${c_yellow}Input test data${c_reset} (choose one):
       test_fasta
       test_fastq
       test_fast5
    """.stripIndent()
}

def defaultMSG(){
    log.info """
    SARS-CoV-2 - Workflow

    \u001B[32mProfile:             $workflow.profile\033[0m
    \033[2mCurrent User:        $workflow.userName
    Nextflow-version:    $nextflow.version
    \u001B[0m
    Pathing:
    \033[2mWorkdir location [-work-Dir]:
        $workflow.workDir
    Output dir [--output]: 
        $params.output
    Databases location [--databases]:
        $params.databases
    Singularity cache dir [--cachedir]: 
        $params.cachedir
    \u001B[1;30m______________________________________\033[0m
    Parameters:
    \033[2mPrimerscheme:        $params.primerV [--primerV]
    Medaka model:        $params.medaka_model [--medaka_model]
    CPUs to use:         $params.cores [--cores]
    Memory in GB:        $params.memory [--memory]\u001B[0m

    \u001B[1;30m______________________________________\033[0m
    """.stripIndent()
}

def v1200_MSG() {
    log.info """
    1200 bp amplicon scheme is used [--primerV V1200]
    \033[2m  --minLength set to 500bp
      --maxLength set to 1500bp\u001B[0m
    \u001B[1;30m______________________________________\033[0m
    """.stripIndent()
}

def basecalling() {
    log.info """
    Basecalling options:
    \033[2mUsing local guppy?      $params.localguppy [--localguppy]  
    One end demultiplexing? $params.one_end [--one_end]
    CPUs for basecalling?   $params.guppy_cpu [--guppy_cpu]
    Basecalling modell:     $params.guppy_model [--guppy_model]\u001B[0m
    \u001B[1;30m______________________________________\033[0m
    """.stripIndent()
}

def rki() {
    log.info """
    RKI output activated:
    \033[2mOutput stored at:    $params.output/$params.rkidir  
    Min Identity to NC_045512.2: $params.seq_threshold [--seq_threshold]
    Min Coverage:        20 [ no parameter]
    Proportion cutoff N: $params.n_threshold [--n_threshold]\u001B[0m
    \u001B[1;30m______________________________________\033[0m
    """.stripIndent()
}
