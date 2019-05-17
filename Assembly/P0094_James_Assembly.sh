
mkdir OriginalRawReads
mkdir Undetermined_indices
mkdir Results
mkdir Code

cp '/home/alemmon/Dropbox/Anchor_Bioinformatics/Code/ProfileUndeterminedIndexes.class' '/home/alemmon/Dropbox/Anchor_Bioinformatics/Code/MergeThread.class' '/home/alemmon/Dropbox/Anchor_Bioinformatics/Code/MergeNode.class' '/home/alemmon/Dropbox/Anchor_Bioinformatics/Code/Merge$1.class' '/home/alemmon/Dropbox/Anchor_Bioinformatics/Code/Merge.class' '/home/alemmon/Dropbox/Anchor_Bioinformatics/Code/WriteAssemblerScript.class' '/home/alemmon/Dropbox/Anchor_Bioinformatics/Code/SuperContig.class' '/home/alemmon/Dropbox/Anchor_Bioinformatics/Code/Read.class' '/home/alemmon/Dropbox/Anchor_Bioinformatics/Code/Nmer.class' '/home/alemmon/Dropbox/Anchor_Bioinformatics/Code/Kmer.class' '/home/alemmon/Dropbox/Anchor_Bioinformatics/Code/Contig.class' '/home/alemmon/Dropbox/Anchor_Bioinformatics/Code/Assembler.class' '/home/alemmon/Dropbox/Anchor_Bioinformatics/Code/AlignedRead.class' '/home/alemmon/Dropbox/Anchor_Bioinformatics/Code/ExtractAssemblySummary2.class' '/home/alemmon/Dropbox/Anchor_Bioinformatics/Code/PlotConSeqLengths.r' '/home/alemmon/Dropbox/Anchor_Bioinformatics/Code/ExtractNMapped.class' '/home/alemmon/Dropbox/Anchor_Bioinformatics/Code/moveToMaster2.sh' Code

rsync -av --progress alemmon@medicine.hpc.fsu.edu:/lustre-med/share/Outputs_CASAVA/Alan_Lemmon-07-26-2013/Project_Piller48/* .
rsync -av --progress alemmon@medicine.hpc.fsu.edu:/lustre-med/share/Outputs_CASAVA/Alan_Lemmon-07-26-2013/Undetermined_indices/* Undetermined_indices/.

gunzip ../Undetermined_indices/Sample_lane1/*R1_001.fastq.gz
cd Code
java -Xmx4000m ProfileUndeterminedIndexes ../Undetermined_indices/Sample_lane1/lane1_Undetermined_L001_R1_001.fastq ../Results/UndeterminedIndexesProfile.txt
#R
#indexCounts<<-read.table("../Results/UndeterminedIndexesProfile.txt")
#max(indexCounts[,2])/sum(indexCounts[,2])
[1] 0.6401948
#head(indexCounts[order(indexCounts[,2],decreasing=T),])
            V1      V2
33286 AACGATAG 2560779
12233 CATAGTCA    9829
51902 CCATAGTA    8673
26261 CGGCGACA    7127
29140 GAAGCTGA    4829
10138 GGAGGCCC    4191

I12765	AACGATAG
java ExtractPairedReadsFromUndetermined ../Undetermined_indices/Sample_lane1/lane1_Undetermined_L001_R1_001.fastq ../Undetermined_indices/Sample_lane1/lane1_Undetermined_L001_R2_001.fastq ../I12765/I12765_R1_0001.fastq ../I12765/I12765_R2_0001.fastq AACGATAG

#MAKE BACKUP COPY OF RAW DATA
cp -r ../Sample* ../OriginalRawReads/.
mv ../Undetermined_indices ../OriginalRawReads/.

rm ../Sample*/SampleSheet.csv
for i in {10066..10113}; do mv ../Sample_P0094_*_I$i ../I$i; done
for i in {10114..10161}; do mv ../Sample_P0094_*_I$i ../I$i; done

gunzip -r ../I*
	#10066 10113 nThreads
run-in-new-tab java -Xmx2000m Merge 10066 10073 4
run-in-new-tab java -Xmx2000m Merge 10074 10081 4
run-in-new-tab java -Xmx2000m Merge 10082 10089 4
run-in-new-tab java -Xmx2000m Merge 10090 10097 4
run-in-new-tab java -Xmx2000m Merge 10098 10105 4
run-in-new-tab java -Xmx2000m Merge 10106 10113 4

run-in-new-tab java -Xmx2000m Merge 10114 10121 5
run-in-new-tab java -Xmx2000m Merge 10122 10129 5
run-in-new-tab java -Xmx2000m Merge 10130 10137 5
run-in-new-tab java -Xmx2000m Merge 10138 10145 5
run-in-new-tab java -Xmx2000m Merge 10146 10153 5
run-in-new-tab java -Xmx2000m Merge 10154 10161 5

java -Xmx2g Merge 12765 12765 6

#PUT THE APPROPRIATE REFERENCE FILES IN THE REFERENCES FOLDER BEFORE PROCEEDING THEY CAN BE FOUND IN DROPBOX

##########################################
java WriteAssemblerScript P0094 10066 10113 ClitelataRefs 3 594 16000 16	#projectID 10066 10113 ReferenceName nRefs nLoci ramMB nThreads
java WriteAssemblerScript P0094 10114 12765 ClitelataRefs 3 594 16000 16	#projectID 10066 10113 ReferenceName nRefs nLoci ramMB nThreads

chmod +x Assemble*.sh
for i in {1..13}; do
    run-in-new-tab ./Assemble_P0094_${i}.sh
done

java -Xmx8000m ExtractAssemblySummary2 10114 12765 594 ../Results/P0094_AssemblySummary #10066 10113 594 outputFileHead

R
source("PlotConSeqLengths.r")
makePlot("P0094",49,594,594,10,200,6000,2500,0.25) #InputFileHead ntaxa 594 594 Possible minReads minLength maxReads maxLength slope
quit()

#NOW COMPUTE INDIVIDUAL-SPECIFIC NMAPPED FILES
java ExtractNMapped 10066 10113

