#!/usr/bin/perl -w
use strict;
use Getopt::Std;

# - - - - - H E A D E R - - - - - - - - - - - - - - - - -
#Take LSA top_terms_by_doc tab-delim EXCEL-MODIFIED worksheets (with same organization as .../07_largeGroupsOnly_defaultN/metadata_groups/original/top_terms_by_doc/genetables/ClusterK_LSA_genetables.xlsx).


# - - - - - O P T I O N S  - - - - - -
my %options=();
getopts("i:t:c:g:n:j:h", \%options);

if ($options{h})
    {   print "\n\nHelp called:\nOptions:\n";
        print "-i = infile\n";
        print "-t = total genomes in cluster of interest\n";
        print "-c = total >70% complete genomes in cluster of interest\n";
        print "-g = total genomes in study\n";
        print "-j = total >70% complete genmes in study\n";
        print "-n = name of cluster of interest (e.g. ClusterK)\n";
	print "-h = This help message\n\n";
	die;
    }

my %GeneDict;

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# - - - - - M A I N - - - - - - - - - - - - - - - - - - - -
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
open(IN, "<$options{i}") or die "\n\nFile $options{i} does not exist or was not given. Try -h for the help file.\n\n";
my @data = <IN>; close(IN); shift(@data);
my $unid = 1000001;
foreach my $line (@data)
	{   	chomp($line);
                my @sep = split('\t', $line);
                $GeneDict{$unid}{'annotation'} = $sep[0];
                $GeneDict{$unid}{'in_cluster'} = $sep[1];
                $GeneDict{$unid}{'out_cluster'} = $sep[2];
                $GeneDict{$unid}{'subsystem_depth1'} = $sep[3];
                $GeneDict{$unid}{'subsystem_depth2'} = $sep[4];
                $GeneDict{$unid}{'subsystem_depth3'} = $sep[5];
                $GeneDict{$unid}{'heme_CXXCH_count'} = $sep[6];
                $GeneDict{$unid}{'heme_CXXXCH_count'} = $sep[7];
                $GeneDict{$unid}{'cluster_rank'} = $sep[8];
                $GeneDict{$unid}{'ClusterP'} = $sep[9];
                $GeneDict{$unid}{'ClusterC'} = $sep[10];
                $GeneDict{$unid}{'ClusterA'} = $sep[11];
                $GeneDict{$unid}{'ClusterD'} = $sep[12];
                $GeneDict{$unid}{'ClusterR'} = $sep[13];
                $GeneDict{$unid}{'ClusterE'} = $sep[14];
                $GeneDict{$unid}{'ClusterG'} = $sep[15];
                $GeneDict{$unid}{'ClusterI'} = $sep[16];
                $GeneDict{$unid}{'ClusterS'} = $sep[17];
                $GeneDict{$unid}{'ClusterJ'} = $sep[18];
                $GeneDict{$unid}{'ClusterM'} = $sep[19];
                $GeneDict{$unid}{'ClusterK'} = $sep[20];
                $GeneDict{$unid}{'ClusterL'} = $sep[21];
                $GeneDict{$unid}{'ClusterN'} = $sep[22];
                $GeneDict{$unid}{'ClusterO'} = $sep[23];
                $GeneDict{$unid}{'ClusterU'} = $sep[24];
                $GeneDict{$unid}{'Orig_Order'} = $sep[25];
                $GeneDict{$unid}{'term_id'} = $sep[26];
                $GeneDict{$unid}{'gene_id'} = $sep[27];
                $GeneDict{$unid}{'perc_in_comp'} = $GeneDict{$unid}{'in_cluster'} / $options{c};
                $GeneDict{$unid}{'perc_in_all'} = $GeneDict{$unid}{'in_cluster'} / $options{t};
                my $g = $options{g};
                my $t = $options{t};
                my $j = $options{j};
                my $c = $options{c};
                my $total_out = $g - $t;
                my $comp_out = $j - $c;
                $GeneDict{$unid}{'perc_out_comp'} = $GeneDict{$unid}{'out_cluster'} / $comp_out;
                $GeneDict{$unid}{'perc_out_all'} = $GeneDict{$unid}{'out_cluster'} / $total_out;
                $unid += 1;
	}
open(OUT2, ">$options{n}"."_cluster1_significantIN_zeroOUT.txt");
open(OUT3, ">$options{n}"."_cluster1_someIN_zeroOUT.txt");
open(OUT4, ">$options{n}"."_cluster1_significantIN_someOUT.txt");
open(OUT5, ">$options{n}"."_cluster1_zeroIN_significantOUT.txt");
open(OUT6, ">$options{n}"."_cluster1_zeroIN_someOUT.txt");
open(OUT7, ">$options{n}"."_cluster1_someIN_significantOUT.txt");
open(OUT8, ">$options{n}"."_cluster1_significantIN_significantOUT.txt");
open(OUT9, ">$options{n}"."_cluster1_someIN_someOUT.txt");
open(OUT10, ">$options{n}"."_cluster2_significantIN_zeroOUT.txt");
open(OUT11, ">$options{n}"."_cluster2_zeroIN_significantOUT.txt");
open(OUT12, ">$options{n}"."_clusterOTHER_significantIN_zeroOUT.txt");
open(OUT13, ">$options{n}"."_clusterOTHER_zeroIN_significantOUT.txt");
open(OUT1, ">$options{n}"."_highestrank_by_lsa.txt");
print OUT1 "annotation\tin_cluster\tperc_in_comp\tout_cluster\tperc_out_comp\tsubsystem_depth1\tsubsystem_depth2\tsubsystem_depth3\theme_CXXCH_count\theme_CXXXCH_count\tcluster_rank\tClusterP\tClusterC\tClusterA\tClusterD\tClusterR\tClusterE\tClusterG\tClusterI\tClusterS\tClusterJ\tClusterM\tClusterK\tClusterL\tClusterN\tClusterO\tClusterU\tOrig_Order\tterm_id\tgene_id\n";
print OUT2 "annotation\tin_cluster\tperc_in_comp\tout_cluster\tperc_out_comp\tsubsystem_depth1\tsubsystem_depth2\tsubsystem_depth3\theme_CXXCH_count\theme_CXXXCH_count\tcluster_rank\tClusterP\tClusterC\tClusterA\tClusterD\tClusterR\tClusterE\tClusterG\tClusterI\tClusterS\tClusterJ\tClusterM\tClusterK\tClusterL\tClusterN\tClusterO\tClusterU\tOrig_Order\tterm_id\tgene_id\n";
print OUT3 "annotation\tin_cluster\tperc_in_comp\tout_cluster\tperc_out_comp\tsubsystem_depth1\tsubsystem_depth2\tsubsystem_depth3\theme_CXXCH_count\theme_CXXXCH_count\tcluster_rank\tClusterP\tClusterC\tClusterA\tClusterD\tClusterR\tClusterE\tClusterG\tClusterI\tClusterS\tClusterJ\tClusterM\tClusterK\tClusterL\tClusterN\tClusterO\tClusterU\tOrig_Order\tterm_id\tgene_id\n";
print OUT4 "annotation\tin_cluster\tperc_in_comp\tout_cluster\tperc_out_comp\tsubsystem_depth1\tsubsystem_depth2\tsubsystem_depth3\theme_CXXCH_count\theme_CXXXCH_count\tcluster_rank\tClusterP\tClusterC\tClusterA\tClusterD\tClusterR\tClusterE\tClusterG\tClusterI\tClusterS\tClusterJ\tClusterM\tClusterK\tClusterL\tClusterN\tClusterO\tClusterU\tOrig_Order\tterm_id\tgene_id\n";
print OUT5 "annotation\tin_cluster\tperc_in_comp\tout_cluster\tperc_out_comp\tsubsystem_depth1\tsubsystem_depth2\tsubsystem_depth3\theme_CXXCH_count\theme_CXXXCH_count\tcluster_rank\tClusterP\tClusterC\tClusterA\tClusterD\tClusterR\tClusterE\tClusterG\tClusterI\tClusterS\tClusterJ\tClusterM\tClusterK\tClusterL\tClusterN\tClusterO\tClusterU\tOrig_Order\tterm_id\tgene_id\n";
print OUT6 "annotation\tin_cluster\tperc_in_comp\tout_cluster\tperc_out_comp\tsubsystem_depth1\tsubsystem_depth2\tsubsystem_depth3\theme_CXXCH_count\theme_CXXXCH_count\tcluster_rank\tClusterP\tClusterC\tClusterA\tClusterD\tClusterR\tClusterE\tClusterG\tClusterI\tClusterS\tClusterJ\tClusterM\tClusterK\tClusterL\tClusterN\tClusterO\tClusterU\tOrig_Order\tterm_id\tgene_id\n";
print OUT7 "annotation\tin_cluster\tperc_in_comp\tout_cluster\tperc_out_comp\tsubsystem_depth1\tsubsystem_depth2\tsubsystem_depth3\theme_CXXCH_count\theme_CXXXCH_count\tcluster_rank\tClusterP\tClusterC\tClusterA\tClusterD\tClusterR\tClusterE\tClusterG\tClusterI\tClusterS\tClusterJ\tClusterM\tClusterK\tClusterL\tClusterN\tClusterO\tClusterU\tOrig_Order\tterm_id\tgene_id\n";
print OUT8 "annotation\tin_cluster\tperc_in_comp\tout_cluster\tperc_out_comp\tsubsystem_depth1\tsubsystem_depth2\tsubsystem_depth3\theme_CXXCH_count\theme_CXXXCH_count\tcluster_rank\tClusterP\tClusterC\tClusterA\tClusterD\tClusterR\tClusterE\tClusterG\tClusterI\tClusterS\tClusterJ\tClusterM\tClusterK\tClusterL\tClusterN\tClusterO\tClusterU\tOrig_Order\tterm_id\tgene_id\n";
print OUT9 "annotation\tin_cluster\tperc_in_comp\tout_cluster\tperc_out_comp\tsubsystem_depth1\tsubsystem_depth2\tsubsystem_depth3\theme_CXXCH_count\theme_CXXXCH_count\tcluster_rank\tClusterP\tClusterC\tClusterA\tClusterD\tClusterR\tClusterE\tClusterG\tClusterI\tClusterS\tClusterJ\tClusterM\tClusterK\tClusterL\tClusterN\tClusterO\tClusterU\tOrig_Order\tterm_id\tgene_id\n";
print OUT10 "annotation\tin_cluster\tperc_in_comp\tout_cluster\tperc_out_comp\tsubsystem_depth1\tsubsystem_depth2\tsubsystem_depth3\theme_CXXCH_count\theme_CXXXCH_count\tcluster_rank\tClusterP\tClusterC\tClusterA\tClusterD\tClusterR\tClusterE\tClusterG\tClusterI\tClusterS\tClusterJ\tClusterM\tClusterK\tClusterL\tClusterN\tClusterO\tClusterU\tOrig_Order\tterm_id\tgene_id\n";
print OUT11 "annotation\tin_cluster\tperc_in_comp\tout_cluster\tperc_out_comp\tsubsystem_depth1\tsubsystem_depth2\tsubsystem_depth3\theme_CXXCH_count\theme_CXXXCH_count\tcluster_rank\tClusterP\tClusterC\tClusterA\tClusterD\tClusterR\tClusterE\tClusterG\tClusterI\tClusterS\tClusterJ\tClusterM\tClusterK\tClusterL\tClusterN\tClusterO\tClusterU\tOrig_Order\tterm_id\tgene_id\n";
print OUT12 "annotation\tin_cluster\tperc_in_comp\tout_cluster\tperc_out_comp\tsubsystem_depth1\tsubsystem_depth2\tsubsystem_depth3\theme_CXXCH_count\theme_CXXXCH_count\tcluster_rank\tClusterP\tClusterC\tClusterA\tClusterD\tClusterR\tClusterE\tClusterG\tClusterI\tClusterS\tClusterJ\tClusterM\tClusterK\tClusterL\tClusterN\tClusterO\tClusterU\tOrig_Order\tterm_id\tgene_id\n";
print OUT13 "annotation\tin_cluster\tperc_in_comp\tout_cluster\tperc_out_comp\tsubsystem_depth1\tsubsystem_depth2\tsubsystem_depth3\theme_CXXCH_count\theme_CXXXCH_count\tcluster_rank\tClusterP\tClusterC\tClusterA\tClusterD\tClusterR\tClusterE\tClusterG\tClusterI\tClusterS\tClusterJ\tClusterM\tClusterK\tClusterL\tClusterN\tClusterO\tClusterU\tOrig_Order\tterm_id\tgene_id\n";

foreach my $i (sort keys %GeneDict)
    {   if ($GeneDict{$i}{'perc_in_comp'} >= 0.7)
            {   if ($GeneDict{$i}{'perc_out_comp'} >= 0.7)
                    {   if ($GeneDict{$i}{'cluster_rank'} == 1)
                            { print OUT8 "$GeneDict{$i}{'annotation'}\t";
                              print OUT8 "$GeneDict{$i}{'in_cluster'}\t";
                              print OUT8 "$GeneDict{$i}{'perc_in_comp'}\t";
                              print OUT8 "$GeneDict{$i}{'out_cluster'}\t";
                              print OUT8 "$GeneDict{$i}{'perc_out_comp'}\t";
                              print OUT8 "$GeneDict{$i}{'subsystem_depth1'}\t";
                              print OUT8 "$GeneDict{$i}{'subsystem_depth2'}\t";
                              print OUT8 "$GeneDict{$i}{'subsystem_depth3'}\t";
                              print OUT8 "$GeneDict{$i}{'heme_CXXCH_count'}\t";
                              print OUT8 "$GeneDict{$i}{'heme_CXXXCH_count'}\t";
                              print OUT8 "$GeneDict{$i}{'cluster_rank'}\t";
                              print OUT8 "$GeneDict{$i}{'ClusterP'}\t";
                              print OUT8 "$GeneDict{$i}{'ClusterC'}\t";
                              print OUT8 "$GeneDict{$i}{'ClusterA'}\t";
                              print OUT8 "$GeneDict{$i}{'ClusterD'}\t";
                              print OUT8 "$GeneDict{$i}{'ClusterR'}\t";
                              print OUT8 "$GeneDict{$i}{'ClusterE'}\t";
                              print OUT8 "$GeneDict{$i}{'ClusterG'}\t";
                              print OUT8 "$GeneDict{$i}{'ClusterI'}\t";
                              print OUT8 "$GeneDict{$i}{'ClusterS'}\t";
                              print OUT8 "$GeneDict{$i}{'ClusterJ'}\t";
                              print OUT8 "$GeneDict{$i}{'ClusterM'}\t";
                              print OUT8 "$GeneDict{$i}{'ClusterK'}\t";
                              print OUT8 "$GeneDict{$i}{'ClusterL'}\t";
                              print OUT8 "$GeneDict{$i}{'ClusterN'}\t";
                              print OUT8 "$GeneDict{$i}{'ClusterO'}\t";
                              print OUT8 "$GeneDict{$i}{'ClusterU'}\t";
                              print OUT8 "$GeneDict{$i}{'Orig_Order'}\t";
                              print OUT8 "$GeneDict{$i}{'term_id'}\t";
                              print OUT8 "$GeneDict{$i}{'gene_id'}\n";  
                            }
                    }
                if ($GeneDict{$i}{'perc_out_comp'} < 0.7 && $GeneDict{$i}{'perc_out_comp'} >= 0.3)
                    {   if ($GeneDict{$i}{'cluster_rank'} == 1)
                            { print OUT4 "$GeneDict{$i}{'annotation'}\t";
                              print OUT4 "$GeneDict{$i}{'in_cluster'}\t";
                              print OUT4 "$GeneDict{$i}{'perc_in_comp'}\t";
                              print OUT4 "$GeneDict{$i}{'out_cluster'}\t";
                              print OUT4 "$GeneDict{$i}{'perc_out_comp'}\t";
                              print OUT4 "$GeneDict{$i}{'subsystem_depth1'}\t";
                              print OUT4 "$GeneDict{$i}{'subsystem_depth2'}\t";
                              print OUT4 "$GeneDict{$i}{'subsystem_depth3'}\t";
                              print OUT4 "$GeneDict{$i}{'heme_CXXCH_count'}\t";
                              print OUT4 "$GeneDict{$i}{'heme_CXXXCH_count'}\t";
                              print OUT4 "$GeneDict{$i}{'cluster_rank'}\t";
                              print OUT4 "$GeneDict{$i}{'ClusterP'}\t";
                              print OUT4 "$GeneDict{$i}{'ClusterC'}\t";
                              print OUT4 "$GeneDict{$i}{'ClusterA'}\t";
                              print OUT4 "$GeneDict{$i}{'ClusterD'}\t";
                              print OUT4 "$GeneDict{$i}{'ClusterR'}\t";
                              print OUT4 "$GeneDict{$i}{'ClusterE'}\t";
                              print OUT4 "$GeneDict{$i}{'ClusterG'}\t";
                              print OUT4 "$GeneDict{$i}{'ClusterI'}\t";
                              print OUT4 "$GeneDict{$i}{'ClusterS'}\t";
                              print OUT4 "$GeneDict{$i}{'ClusterJ'}\t";
                              print OUT4 "$GeneDict{$i}{'ClusterM'}\t";
                              print OUT4 "$GeneDict{$i}{'ClusterK'}\t";
                              print OUT4 "$GeneDict{$i}{'ClusterL'}\t";
                              print OUT4 "$GeneDict{$i}{'ClusterN'}\t";
                              print OUT4 "$GeneDict{$i}{'ClusterO'}\t";
                              print OUT4 "$GeneDict{$i}{'ClusterU'}\t";
                              print OUT4 "$GeneDict{$i}{'Orig_Order'}\t";
                              print OUT4 "$GeneDict{$i}{'term_id'}\t";
                              print OUT4 "$GeneDict{$i}{'gene_id'}\n";
                                
                            }
            
                    }
                if ($GeneDict{$i}{'perc_out_comp'} == 0)
                    {   if ($GeneDict{$i}{'cluster_rank'} == 1)
                            { print OUT2 "$GeneDict{$i}{'annotation'}\t";
                              print OUT2 "$GeneDict{$i}{'in_cluster'}\t";
                              print OUT2 "$GeneDict{$i}{'perc_in_comp'}\t";
                              print OUT2 "$GeneDict{$i}{'out_cluster'}\t";
                              print OUT2 "$GeneDict{$i}{'perc_out_comp'}\t";
                              print OUT2 "$GeneDict{$i}{'subsystem_depth1'}\t";
                              print OUT2 "$GeneDict{$i}{'subsystem_depth2'}\t";
                              print OUT2 "$GeneDict{$i}{'subsystem_depth3'}\t";
                              print OUT2 "$GeneDict{$i}{'heme_CXXCH_count'}\t";
                              print OUT2 "$GeneDict{$i}{'heme_CXXXCH_count'}\t";
                              print OUT2 "$GeneDict{$i}{'cluster_rank'}\t";
                              print OUT2 "$GeneDict{$i}{'ClusterP'}\t";
                              print OUT2 "$GeneDict{$i}{'ClusterC'}\t";
                              print OUT2 "$GeneDict{$i}{'ClusterA'}\t";
                              print OUT2 "$GeneDict{$i}{'ClusterD'}\t";
                              print OUT2 "$GeneDict{$i}{'ClusterR'}\t";
                              print OUT2 "$GeneDict{$i}{'ClusterE'}\t";
                              print OUT2 "$GeneDict{$i}{'ClusterG'}\t";
                              print OUT2 "$GeneDict{$i}{'ClusterI'}\t";
                              print OUT2 "$GeneDict{$i}{'ClusterS'}\t";
                              print OUT2 "$GeneDict{$i}{'ClusterJ'}\t";
                              print OUT2 "$GeneDict{$i}{'ClusterM'}\t";
                              print OUT2 "$GeneDict{$i}{'ClusterK'}\t";
                              print OUT2 "$GeneDict{$i}{'ClusterL'}\t";
                              print OUT2 "$GeneDict{$i}{'ClusterN'}\t";
                              print OUT2 "$GeneDict{$i}{'ClusterO'}\t";
                              print OUT2 "$GeneDict{$i}{'ClusterU'}\t";
                              print OUT2 "$GeneDict{$i}{'Orig_Order'}\t";
                              print OUT2 "$GeneDict{$i}{'term_id'}\t";
                              print OUT2 "$GeneDict{$i}{'gene_id'}\n";
                            }
                        if ($GeneDict{$i}{'cluster_rank'} == 2)
                            { print OUT10 "$GeneDict{$i}{'annotation'}\t";
                              print OUT10 "$GeneDict{$i}{'in_cluster'}\t";
                              print OUT10 "$GeneDict{$i}{'perc_in_comp'}\t";
                              print OUT10 "$GeneDict{$i}{'out_cluster'}\t";
                              print OUT10 "$GeneDict{$i}{'perc_out_comp'}\t";
                              print OUT10 "$GeneDict{$i}{'subsystem_depth1'}\t";
                              print OUT10 "$GeneDict{$i}{'subsystem_depth2'}\t";
                              print OUT10 "$GeneDict{$i}{'subsystem_depth3'}\t";
                              print OUT10 "$GeneDict{$i}{'heme_CXXCH_count'}\t";
                              print OUT10 "$GeneDict{$i}{'heme_CXXXCH_count'}\t";
                              print OUT10 "$GeneDict{$i}{'cluster_rank'}\t";
                              print OUT10 "$GeneDict{$i}{'ClusterP'}\t";
                              print OUT10 "$GeneDict{$i}{'ClusterC'}\t";
                              print OUT10 "$GeneDict{$i}{'ClusterA'}\t";
                              print OUT10 "$GeneDict{$i}{'ClusterD'}\t";
                              print OUT10 "$GeneDict{$i}{'ClusterR'}\t";
                              print OUT10 "$GeneDict{$i}{'ClusterE'}\t";
                              print OUT10 "$GeneDict{$i}{'ClusterG'}\t";
                              print OUT10 "$GeneDict{$i}{'ClusterI'}\t";
                              print OUT10 "$GeneDict{$i}{'ClusterS'}\t";
                              print OUT10 "$GeneDict{$i}{'ClusterJ'}\t";
                              print OUT10 "$GeneDict{$i}{'ClusterM'}\t";
                              print OUT10 "$GeneDict{$i}{'ClusterK'}\t";
                              print OUT10 "$GeneDict{$i}{'ClusterL'}\t";
                              print OUT10 "$GeneDict{$i}{'ClusterN'}\t";
                              print OUT10 "$GeneDict{$i}{'ClusterO'}\t";
                              print OUT10 "$GeneDict{$i}{'ClusterU'}\t";
                              print OUT10 "$GeneDict{$i}{'Orig_Order'}\t";
                              print OUT10 "$GeneDict{$i}{'term_id'}\t";
                              print OUT10 "$GeneDict{$i}{'gene_id'}\n";
                            
                            }
                        if ($GeneDict{$i}{'cluster_rank'} > 2)
                            { print OUT12 "$GeneDict{$i}{'annotation'}\t";
                              print OUT12 "$GeneDict{$i}{'in_cluster'}\t";
                              print OUT12 "$GeneDict{$i}{'perc_in_comp'}\t";
                              print OUT12 "$GeneDict{$i}{'out_cluster'}\t";
                              print OUT12 "$GeneDict{$i}{'perc_out_comp'}\t";
                              print OUT12 "$GeneDict{$i}{'subsystem_depth1'}\t";
                              print OUT12 "$GeneDict{$i}{'subsystem_depth2'}\t";
                              print OUT12 "$GeneDict{$i}{'subsystem_depth3'}\t";
                              print OUT12 "$GeneDict{$i}{'heme_CXXCH_count'}\t";
                              print OUT12 "$GeneDict{$i}{'heme_CXXXCH_count'}\t";
                              print OUT12 "$GeneDict{$i}{'cluster_rank'}\t";
                              print OUT12 "$GeneDict{$i}{'ClusterP'}\t";
                              print OUT12 "$GeneDict{$i}{'ClusterC'}\t";
                              print OUT12 "$GeneDict{$i}{'ClusterA'}\t";
                              print OUT12 "$GeneDict{$i}{'ClusterD'}\t";
                              print OUT12 "$GeneDict{$i}{'ClusterR'}\t";
                              print OUT12 "$GeneDict{$i}{'ClusterE'}\t";
                              print OUT12 "$GeneDict{$i}{'ClusterG'}\t";
                              print OUT12 "$GeneDict{$i}{'ClusterI'}\t";
                              print OUT12 "$GeneDict{$i}{'ClusterS'}\t";
                              print OUT12 "$GeneDict{$i}{'ClusterJ'}\t";
                              print OUT12 "$GeneDict{$i}{'ClusterM'}\t";
                              print OUT12 "$GeneDict{$i}{'ClusterK'}\t";
                              print OUT12 "$GeneDict{$i}{'ClusterL'}\t";
                              print OUT12 "$GeneDict{$i}{'ClusterN'}\t";
                              print OUT12 "$GeneDict{$i}{'ClusterO'}\t";
                              print OUT12 "$GeneDict{$i}{'ClusterU'}\t";
                              print OUT12 "$GeneDict{$i}{'Orig_Order'}\t";
                              print OUT12 "$GeneDict{$i}{'term_id'}\t";
                              print OUT12 "$GeneDict{$i}{'gene_id'}\n";
                            
                            }
            
                    }
            }
        if ($GeneDict{$i}{'perc_in_comp'} < 0.7 && $GeneDict{$i}{'perc_in_comp'} >= 0.3)
            {   if ($GeneDict{$i}{'perc_out_comp'} >= 0.7)
                    {   if ($GeneDict{$i}{'cluster_rank'} == 1)
                            { print OUT7 "$GeneDict{$i}{'annotation'}\t";
                              print OUT7 "$GeneDict{$i}{'in_cluster'}\t";
                              print OUT7 "$GeneDict{$i}{'perc_in_comp'}\t";
                              print OUT7 "$GeneDict{$i}{'out_cluster'}\t";
                              print OUT7 "$GeneDict{$i}{'perc_out_comp'}\t";
                              print OUT7 "$GeneDict{$i}{'subsystem_depth1'}\t";
                              print OUT7 "$GeneDict{$i}{'subsystem_depth2'}\t";
                              print OUT7 "$GeneDict{$i}{'subsystem_depth3'}\t";
                              print OUT7 "$GeneDict{$i}{'heme_CXXCH_count'}\t";
                              print OUT7 "$GeneDict{$i}{'heme_CXXXCH_count'}\t";
                              print OUT7 "$GeneDict{$i}{'cluster_rank'}\t";
                              print OUT7 "$GeneDict{$i}{'ClusterP'}\t";
                              print OUT7 "$GeneDict{$i}{'ClusterC'}\t";
                              print OUT7 "$GeneDict{$i}{'ClusterA'}\t";
                              print OUT7 "$GeneDict{$i}{'ClusterD'}\t";
                              print OUT7 "$GeneDict{$i}{'ClusterR'}\t";
                              print OUT7 "$GeneDict{$i}{'ClusterE'}\t";
                              print OUT7 "$GeneDict{$i}{'ClusterG'}\t";
                              print OUT7 "$GeneDict{$i}{'ClusterI'}\t";
                              print OUT7 "$GeneDict{$i}{'ClusterS'}\t";
                              print OUT7 "$GeneDict{$i}{'ClusterJ'}\t";
                              print OUT7 "$GeneDict{$i}{'ClusterM'}\t";
                              print OUT7 "$GeneDict{$i}{'ClusterK'}\t";
                              print OUT7 "$GeneDict{$i}{'ClusterL'}\t";
                              print OUT7 "$GeneDict{$i}{'ClusterN'}\t";
                              print OUT7 "$GeneDict{$i}{'ClusterO'}\t";
                              print OUT7 "$GeneDict{$i}{'ClusterU'}\t";
                              print OUT7 "$GeneDict{$i}{'Orig_Order'}\t";
                              print OUT7 "$GeneDict{$i}{'term_id'}\t";
                              print OUT7 "$GeneDict{$i}{'gene_id'}\n";
                                
                            }
                        
                    }
                if ($GeneDict{$i}{'perc_out_comp'} < 0.7 && $GeneDict{$i}{'perc_out_comp'} >= 0.3)
                    {   if ($GeneDict{$i}{'cluster_rank'} == 1)
                            { print OUT9 "$GeneDict{$i}{'annotation'}\t";
                              print OUT9 "$GeneDict{$i}{'in_cluster'}\t";
                              print OUT9 "$GeneDict{$i}{'perc_in_comp'}\t";
                              print OUT9 "$GeneDict{$i}{'out_cluster'}\t";
                              print OUT9 "$GeneDict{$i}{'perc_out_comp'}\t";
                              print OUT9 "$GeneDict{$i}{'subsystem_depth1'}\t";
                              print OUT9 "$GeneDict{$i}{'subsystem_depth2'}\t";
                              print OUT9 "$GeneDict{$i}{'subsystem_depth3'}\t";
                              print OUT9 "$GeneDict{$i}{'heme_CXXCH_count'}\t";
                              print OUT9 "$GeneDict{$i}{'heme_CXXXCH_count'}\t";
                              print OUT9 "$GeneDict{$i}{'cluster_rank'}\t";
                              print OUT9 "$GeneDict{$i}{'ClusterP'}\t";
                              print OUT9 "$GeneDict{$i}{'ClusterC'}\t";
                              print OUT9 "$GeneDict{$i}{'ClusterA'}\t";
                              print OUT9 "$GeneDict{$i}{'ClusterD'}\t";
                              print OUT9 "$GeneDict{$i}{'ClusterR'}\t";
                              print OUT9 "$GeneDict{$i}{'ClusterE'}\t";
                              print OUT9 "$GeneDict{$i}{'ClusterG'}\t";
                              print OUT9 "$GeneDict{$i}{'ClusterI'}\t";
                              print OUT9 "$GeneDict{$i}{'ClusterS'}\t";
                              print OUT9 "$GeneDict{$i}{'ClusterJ'}\t";
                              print OUT9 "$GeneDict{$i}{'ClusterM'}\t";
                              print OUT9 "$GeneDict{$i}{'ClusterK'}\t";
                              print OUT9 "$GeneDict{$i}{'ClusterL'}\t";
                              print OUT9 "$GeneDict{$i}{'ClusterN'}\t";
                              print OUT9 "$GeneDict{$i}{'ClusterO'}\t";
                              print OUT9 "$GeneDict{$i}{'ClusterU'}\t";
                              print OUT9 "$GeneDict{$i}{'Orig_Order'}\t";
                              print OUT9 "$GeneDict{$i}{'term_id'}\t";
                              print OUT9 "$GeneDict{$i}{'gene_id'}\n";
                                
                            }
            
                    }
                if ($GeneDict{$i}{'perc_out_comp'} == 0)
                    {   if ($GeneDict{$i}{'cluster_rank'} == 1)
                            { print OUT3 "$GeneDict{$i}{'annotation'}\t";
                              print OUT3 "$GeneDict{$i}{'in_cluster'}\t";
                              print OUT3 "$GeneDict{$i}{'perc_in_comp'}\t";
                              print OUT3 "$GeneDict{$i}{'out_cluster'}\t";
                              print OUT3 "$GeneDict{$i}{'perc_out_comp'}\t";
                              print OUT3 "$GeneDict{$i}{'subsystem_depth1'}\t";
                              print OUT3 "$GeneDict{$i}{'subsystem_depth2'}\t";
                              print OUT3 "$GeneDict{$i}{'subsystem_depth3'}\t";
                              print OUT3 "$GeneDict{$i}{'heme_CXXCH_count'}\t";
                              print OUT3 "$GeneDict{$i}{'heme_CXXXCH_count'}\t";
                              print OUT3 "$GeneDict{$i}{'cluster_rank'}\t";
                              print OUT3 "$GeneDict{$i}{'ClusterP'}\t";
                              print OUT3 "$GeneDict{$i}{'ClusterC'}\t";
                              print OUT3 "$GeneDict{$i}{'ClusterA'}\t";
                              print OUT3 "$GeneDict{$i}{'ClusterD'}\t";
                              print OUT3 "$GeneDict{$i}{'ClusterR'}\t";
                              print OUT3 "$GeneDict{$i}{'ClusterE'}\t";
                              print OUT3 "$GeneDict{$i}{'ClusterG'}\t";
                              print OUT3 "$GeneDict{$i}{'ClusterI'}\t";
                              print OUT3 "$GeneDict{$i}{'ClusterS'}\t";
                              print OUT3 "$GeneDict{$i}{'ClusterJ'}\t";
                              print OUT3 "$GeneDict{$i}{'ClusterM'}\t";
                              print OUT3 "$GeneDict{$i}{'ClusterK'}\t";
                              print OUT3 "$GeneDict{$i}{'ClusterL'}\t";
                              print OUT3 "$GeneDict{$i}{'ClusterN'}\t";
                              print OUT3 "$GeneDict{$i}{'ClusterO'}\t";
                              print OUT3 "$GeneDict{$i}{'ClusterU'}\t";
                              print OUT3 "$GeneDict{$i}{'Orig_Order'}\t";
                              print OUT3 "$GeneDict{$i}{'term_id'}\t";
                              print OUT3 "$GeneDict{$i}{'gene_id'}\n";
                                
                            }
            
            
                    }
            
            }
        if ($GeneDict{$i}{'perc_in_comp'} == 0)
            {   if ($GeneDict{$i}{'perc_out_comp'} >= 0.7)
                    {   if ($GeneDict{$i}{'cluster_rank'} == 1)
                            { print OUT5 "$GeneDict{$i}{'annotation'}\t";
                              print OUT5 "$GeneDict{$i}{'in_cluster'}\t";
                              print OUT5 "$GeneDict{$i}{'perc_in_comp'}\t";
                              print OUT5 "$GeneDict{$i}{'out_cluster'}\t";
                              print OUT5 "$GeneDict{$i}{'perc_out_comp'}\t";
                              print OUT5 "$GeneDict{$i}{'subsystem_depth1'}\t";
                              print OUT5 "$GeneDict{$i}{'subsystem_depth2'}\t";
                              print OUT5 "$GeneDict{$i}{'subsystem_depth3'}\t";
                              print OUT5 "$GeneDict{$i}{'heme_CXXCH_count'}\t";
                              print OUT5 "$GeneDict{$i}{'heme_CXXXCH_count'}\t";
                              print OUT5 "$GeneDict{$i}{'cluster_rank'}\t";
                              print OUT5 "$GeneDict{$i}{'ClusterP'}\t";
                              print OUT5 "$GeneDict{$i}{'ClusterC'}\t";
                              print OUT5 "$GeneDict{$i}{'ClusterA'}\t";
                              print OUT5 "$GeneDict{$i}{'ClusterD'}\t";
                              print OUT5 "$GeneDict{$i}{'ClusterR'}\t";
                              print OUT5 "$GeneDict{$i}{'ClusterE'}\t";
                              print OUT5 "$GeneDict{$i}{'ClusterG'}\t";
                              print OUT5 "$GeneDict{$i}{'ClusterI'}\t";
                              print OUT5 "$GeneDict{$i}{'ClusterS'}\t";
                              print OUT5 "$GeneDict{$i}{'ClusterJ'}\t";
                              print OUT5 "$GeneDict{$i}{'ClusterM'}\t";
                              print OUT5 "$GeneDict{$i}{'ClusterK'}\t";
                              print OUT5 "$GeneDict{$i}{'ClusterL'}\t";
                              print OUT5 "$GeneDict{$i}{'ClusterN'}\t";
                              print OUT5 "$GeneDict{$i}{'ClusterO'}\t";
                              print OUT5 "$GeneDict{$i}{'ClusterU'}\t";
                              print OUT5 "$GeneDict{$i}{'Orig_Order'}\t";
                              print OUT5 "$GeneDict{$i}{'term_id'}\t";
                              print OUT5 "$GeneDict{$i}{'gene_id'}\n";
                                
                            }
                        if ($GeneDict{$i}{'cluster_rank'} == 2)
                            { print OUT11 "$GeneDict{$i}{'annotation'}\t";
                              print OUT11 "$GeneDict{$i}{'in_cluster'}\t";
                              print OUT11 "$GeneDict{$i}{'perc_in_comp'}\t";
                              print OUT11 "$GeneDict{$i}{'out_cluster'}\t";
                              print OUT11 "$GeneDict{$i}{'perc_out_comp'}\t";
                              print OUT11 "$GeneDict{$i}{'subsystem_depth1'}\t";
                              print OUT11 "$GeneDict{$i}{'subsystem_depth2'}\t";
                              print OUT11 "$GeneDict{$i}{'subsystem_depth3'}\t";
                              print OUT11 "$GeneDict{$i}{'heme_CXXCH_count'}\t";
                              print OUT11 "$GeneDict{$i}{'heme_CXXXCH_count'}\t";
                              print OUT11 "$GeneDict{$i}{'cluster_rank'}\t";
                              print OUT11 "$GeneDict{$i}{'ClusterP'}\t";
                              print OUT11 "$GeneDict{$i}{'ClusterC'}\t";
                              print OUT11 "$GeneDict{$i}{'ClusterA'}\t";
                              print OUT11 "$GeneDict{$i}{'ClusterD'}\t";
                              print OUT11 "$GeneDict{$i}{'ClusterR'}\t";
                              print OUT11 "$GeneDict{$i}{'ClusterE'}\t";
                              print OUT11 "$GeneDict{$i}{'ClusterG'}\t";
                              print OUT11 "$GeneDict{$i}{'ClusterI'}\t";
                              print OUT11 "$GeneDict{$i}{'ClusterS'}\t";
                              print OUT11 "$GeneDict{$i}{'ClusterJ'}\t";
                              print OUT11 "$GeneDict{$i}{'ClusterM'}\t";
                              print OUT11 "$GeneDict{$i}{'ClusterK'}\t";
                              print OUT11 "$GeneDict{$i}{'ClusterL'}\t";
                              print OUT11 "$GeneDict{$i}{'ClusterN'}\t";
                              print OUT11 "$GeneDict{$i}{'ClusterO'}\t";
                              print OUT11 "$GeneDict{$i}{'ClusterU'}\t";
                              print OUT11 "$GeneDict{$i}{'Orig_Order'}\t";
                              print OUT11 "$GeneDict{$i}{'term_id'}\t";
                              print OUT11 "$GeneDict{$i}{'gene_id'}\n";
                            
                            }
                        if ($GeneDict{$i}{'cluster_rank'} > 2)
                            { print OUT13 "$GeneDict{$i}{'annotation'}\t";
                              print OUT13 "$GeneDict{$i}{'in_cluster'}\t";
                              print OUT13 "$GeneDict{$i}{'perc_in_comp'}\t";
                              print OUT13 "$GeneDict{$i}{'out_cluster'}\t";
                              print OUT13 "$GeneDict{$i}{'perc_out_comp'}\t";
                              print OUT13 "$GeneDict{$i}{'subsystem_depth1'}\t";
                              print OUT13 "$GeneDict{$i}{'subsystem_depth2'}\t";
                              print OUT13 "$GeneDict{$i}{'subsystem_depth3'}\t";
                              print OUT13 "$GeneDict{$i}{'heme_CXXCH_count'}\t";
                              print OUT13 "$GeneDict{$i}{'heme_CXXXCH_count'}\t";
                              print OUT13 "$GeneDict{$i}{'cluster_rank'}\t";
                              print OUT13 "$GeneDict{$i}{'ClusterP'}\t";
                              print OUT13 "$GeneDict{$i}{'ClusterC'}\t";
                              print OUT13 "$GeneDict{$i}{'ClusterA'}\t";
                              print OUT13 "$GeneDict{$i}{'ClusterD'}\t";
                              print OUT13 "$GeneDict{$i}{'ClusterR'}\t";
                              print OUT13 "$GeneDict{$i}{'ClusterE'}\t";
                              print OUT13 "$GeneDict{$i}{'ClusterG'}\t";
                              print OUT13 "$GeneDict{$i}{'ClusterI'}\t";
                              print OUT13 "$GeneDict{$i}{'ClusterS'}\t";
                              print OUT13 "$GeneDict{$i}{'ClusterJ'}\t";
                              print OUT13 "$GeneDict{$i}{'ClusterM'}\t";
                              print OUT13 "$GeneDict{$i}{'ClusterK'}\t";
                              print OUT13 "$GeneDict{$i}{'ClusterL'}\t";
                              print OUT13 "$GeneDict{$i}{'ClusterN'}\t";
                              print OUT13 "$GeneDict{$i}{'ClusterO'}\t";
                              print OUT13 "$GeneDict{$i}{'ClusterU'}\t";
                              print OUT13 "$GeneDict{$i}{'Orig_Order'}\t";
                              print OUT13 "$GeneDict{$i}{'term_id'}\t";
                              print OUT13 "$GeneDict{$i}{'gene_id'}\n";
                            
                            }
                    }
                if ($GeneDict{$i}{'perc_out_comp'} < 0.7 && $GeneDict{$i}{'perc_out_comp'} >= 0.3)
                    {   if ($GeneDict{$i}{'cluster_rank'} == 1)
                            { print OUT6 "$GeneDict{$i}{'annotation'}\t";
                              print OUT6 "$GeneDict{$i}{'in_cluster'}\t";
                              print OUT6 "$GeneDict{$i}{'perc_in_comp'}\t";
                              print OUT6 "$GeneDict{$i}{'out_cluster'}\t";
                              print OUT6 "$GeneDict{$i}{'perc_out_comp'}\t";
                              print OUT6 "$GeneDict{$i}{'subsystem_depth1'}\t";
                              print OUT6 "$GeneDict{$i}{'subsystem_depth2'}\t";
                              print OUT6 "$GeneDict{$i}{'subsystem_depth3'}\t";
                              print OUT6 "$GeneDict{$i}{'heme_CXXCH_count'}\t";
                              print OUT6 "$GeneDict{$i}{'heme_CXXXCH_count'}\t";
                              print OUT6 "$GeneDict{$i}{'cluster_rank'}\t";
                              print OUT6 "$GeneDict{$i}{'ClusterP'}\t";
                              print OUT6 "$GeneDict{$i}{'ClusterC'}\t";
                              print OUT6 "$GeneDict{$i}{'ClusterA'}\t";
                              print OUT6 "$GeneDict{$i}{'ClusterD'}\t";
                              print OUT6 "$GeneDict{$i}{'ClusterR'}\t";
                              print OUT6 "$GeneDict{$i}{'ClusterE'}\t";
                              print OUT6 "$GeneDict{$i}{'ClusterG'}\t";
                              print OUT6 "$GeneDict{$i}{'ClusterI'}\t";
                              print OUT6 "$GeneDict{$i}{'ClusterS'}\t";
                              print OUT6 "$GeneDict{$i}{'ClusterJ'}\t";
                              print OUT6 "$GeneDict{$i}{'ClusterM'}\t";
                              print OUT6 "$GeneDict{$i}{'ClusterK'}\t";
                              print OUT6 "$GeneDict{$i}{'ClusterL'}\t";
                              print OUT6 "$GeneDict{$i}{'ClusterN'}\t";
                              print OUT6 "$GeneDict{$i}{'ClusterO'}\t";
                              print OUT6 "$GeneDict{$i}{'ClusterU'}\t";
                              print OUT6 "$GeneDict{$i}{'Orig_Order'}\t";
                              print OUT6 "$GeneDict{$i}{'term_id'}\t";
                              print OUT6 "$GeneDict{$i}{'gene_id'}\n";
                                
                            }
            
                    }
            
            
            }
        
    }

print OUT1 "IN PROGRESS\n\n";
close(OUT1); close(OUT2); close(OUT3); close(OUT4); close(OUT5); close(OUT6); close(OUT7); close(OUT8); close(OUT9);
close(OUT10); close(OUT11); close(OUT12); close(OUT13);




# - - - - - EOF - - - - - - - - - - - - - - - - - - - - - -