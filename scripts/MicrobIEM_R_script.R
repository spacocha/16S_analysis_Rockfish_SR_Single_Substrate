source("./MicrobIEM/MicrobIEM_decontamination.R")
featurefile <- read.delim("./merged_dada2_MicrobIEM_dir/feature-table.biom.txt3",row.names = 1)
taxa<- read.delim("./emp_paired_MPA_taxonomy_export_dir/taxonomy.tsv", row.names = 1)
MicrobIEM_featurefile <-data.frame(featurefile, taxa[1])
controlNames <- read.delim("../../db/control_sample_list.txt2")
PCinx<-match(controlNames[,1],c(colnames(MicrobIEM_featurefile)))
NEG1names<-colnames(MicrobIEM_featurefile[PCinx])
SAMPLEnames<-c(colnames(MicrobIEM_featurefile))[-PCinx]
results<-MicrobIEM_decontamination(MicrobIEM_featurefile,SAMPLE=SAMPLEnames[1:160],NEG1=NEG1names,ratio_NEG1_threshold=2,span_NEG1_threshold=0.1)
ASV_names<-results[,1]
contam<-results[,10]
contaminx<-grep("TRUE",contam)
ASV_contam_names<-c("featureid",ASV_names[contaminx])
write(ASV_contam_names, "ASV_contam_names.txt")
write.table(results, "MicrobIEM_results.txt")

