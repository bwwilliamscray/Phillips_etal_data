//Overview of AHE Assembly Pipeline for Williams-etal2019
//(Refer to P0094_James_Assembly.sh script for an example)
//Note that these script contains some hardcoded file paths
1) Create an analysis folder
2) Copy the Code and References folders into the analysis folder
3) Open a terminal window and navigate into the code folder
4) Use “javac *.java” to compile all of the java code (all Java and R programs will be executed from inside this folder).
5) Download raw reads from sequencing center, the raw reads for each individual should be placed a folder corresponding to a sample number in the following foramt I1213, where 1213 is the sample number of the individual.
6) Decompress the fastq files found in each of the I folders
7) Merge overlapping reads using the Merge.java program (Command given in P0094_James_Assembly.sh script file. Note that each execution of this program merges individuals within the range provided, with the number of threads specified. This allows for parallel application, as can be seen in the Assembly script file
8) Once merged, use the WriteAssemblerScript program to write the assembler scripts that will produce files named like Assemble*.sh. each of these can be executed in parallel. Each execution (thread) will require 16GB of RAM.
9) Once the assemblies are finished, a summary of the assembly results can be gained from using the ExtractAssemblySummary2
10) The R script “PlotConSeqLengths.r” can be used to make plots of the assembly summary.
11) Extract the coverage levels for each locus for each individual using the ExtractNMapped java program, as seen in the Assembly script.

//Overview of post-Assembly Pipeline (orthology and alignment) for Williams-etal2019
//(Refer to T385_James_PostAssembly.sh script for an example)
//Note that these script contains some hardcoded file paths
1) Determine coverage thresholds using identifyGoodSeqs R script
2) Perform the coverage filtering and gather the homologous sequences using the GatherALLConSeqsWithOKCoverage2 java program
3) Compute pairwise distance measures using the GetPairwiseDistanceMeasures java program
4) Perform orthology assessment using the commands given in the Orthology section of the PostAssembly script.
5) Sort the homologs by orthology cluster using SortSequencesViaOrthoSetsC java program
6) Align all of the resulting fasta files using MAFFT
7) Trim and mask alignments using TrimAndMaskRawAlignments3 java program
8) Estimate the phylogeny using RAxML, then use Astral to estimate the species tree
