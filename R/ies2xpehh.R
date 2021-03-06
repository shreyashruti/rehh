ies2xpehh <- function(hh_pop1,hh_pop2,popname1 = NA,popname2 = NA,method = "bilateral") {
	if ((colnames(hh_pop1)[7] != "iES_Sabeti_et_al_2007") || (colnames(hh_pop2)[7] != "iES_Sabeti_et_al_2007")) {stop("Unrecognized column name for iES: the data are not data frames generated by the scan_hh() function...")}
	if (!(method %in% c("unilateral","bilateral"))) {stop("Unknown method: must be either unilateral or bilateral...")}
	if (!(nrow(hh_pop1) == nrow(hh_pop2))) {stop("hh_pop1 and hh_pop2 must have the same dimensions")}
	if (sum(hh_pop1[,2] == hh_pop2[,2]) < nrow(hh_pop1)) {stop("SNP positions in hh_pop1 and hh_pop2 must be identical")}


	if (sum(hh_pop1$POSITION == hh_pop2$POSITION) < nrow(hh_pop1)) {stop("SNP positions in hh_pop1 and hh_pop2 must be identical")}
	ies_1 = hh_pop1$iES_Sabeti_et_al_2007
	ies_2 = hh_pop2$iES_Sabeti_et_al_2007
	tmp_xpehh_nc = log(ies_1 / ies_2)
	tmp_med = median(tmp_xpehh_nc,na.rm = T)
	tmp_sd = sd(tmp_xpehh_nc,na.rm = T)
	xpehh_cor = (tmp_xpehh_nc - tmp_med) / tmp_sd
	tmp_pval = xpehh_cor * 0
	if (method == "bilateral") {
		tmp_pval = -1 * log10(1 - 2 * abs(pnorm(xpehh_cor) - 0.5))
	}
	else {
		tmp_pval = -1 * log10(1 - pnorm(xpehh_cor))
	}
	tmp_pval2 = tmp_pval
	tmp_pval2[tmp_pval2 == "Inf"] = NA  
	tmp_pval[tmp_pval == "Inf"] = max(tmp_pval2,na.rm = TRUE) + 1 
	res.xpehh = data.frame(hh_pop1$CHR,hh_pop1$POSITION,xpehh_cor,tmp_pval,stringsAsFactors=FALSE,row.names=rownames(hh_pop1))
	if(is.na(popname1) | is.na(popname2)){dum.nom="XPEHH"}else{dum.nom=paste("XPEHH (",popname1," vs. ",popname2,")",sep="")}
	colnames(res.xpehh)=c("CHR","POSITION",dum.nom,paste("-log10(p-value) [",method,"]",sep = ""))
 	return(res.xpehh)
}
