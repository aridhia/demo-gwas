
setwd("/home/gabi/Desktop/gwas_tutorial/test")

# Plot the first 5 principal components
pcs = read.table("pca.eigenvec")
colnames(pcs)[3:7] = c("PC1", "PC2", "PC3", "PC4", "PC5")
write.table(pcs, file = "pca2.eigenvec", sep = "")

palette = c("red2", "green2", "blue2", "yellow3", "grey40", "grey70", "purple")
pcs$colour = palette[as.integer(pcs[, 1])]
plot(pcs[, 3:7], col=pcs$colour, lower.panel=NULL)
legend(0.1, 0.5, col=palette, legend=levels(pcs[, 1]), pch = c(rep(4, 4), rep(20, 3)), xpd=NA )


# Make a scree plot -> helps to decide how many PCs to include in the analysis
eigenvals = read.table("pca.eigenval")
eigen <- eigenvals[['V1']]

num = 1:20
plot(num, eigen, xlab ="Factor number", ylab="Eigenvalue", col="blue")


# Estimate genomic inflation factor
"estlambda" <- function(data, plot=FALSE, proportion=1.0,
                        method="regression", filter=TRUE, df=1,... ) {
  data <- data[which(!is.na(data))]
  if (proportion>1.0 || proportion<=0)
    stop("proportion argument should be greater then zero and less than or equal to one")
  
  ntp <- round( proportion * length(data) )
  if ( ntp<1 ) stop("no valid measurements")
  if ( ntp==1 ) {
    warning(paste("One measurement, lambda = 1 returned"))
    return(list(estimate=1.0, se=999.99))
  }
  if ( ntp<10 ) warning(paste("number of points is too small:", ntp))
  if ( min(data)<0 ) stop("data argument has values <0")
  if ( max(data)<=1 ) {
    #       lt16 <- (data < 1.e-16)
    #       if (any(lt16)) {
    #           warning(paste("Some probabilities < 1.e-16; set to 1.e-16"))
    #           data[lt16] <- 1.e-16
    #       }
    data <- qchisq(data, 1, lower.tail=FALSE)
  }
  if (filter)
  {
    data[which(abs(data)<1e-8)] <- NA
  }
  data <- sort(data)
  ppoi <- ppoints(data)
  ppoi <- sort(qchisq(ppoi, df=df, lower.tail=FALSE))
  data <- data[1:ntp]
  ppoi <- ppoi[1:ntp]
  # s <- summary(lm(data~offset(ppoi)))$coeff
  #       bug fix thanks to Franz Quehenberger
  
  out <- list()
  if (method=="regression") {
    s <- summary( lm(data~0+ppoi) )$coeff
    out$estimate <- s[1,1]
    out$se <- s[1,2]
  } else if (method=="median") {
    out$estimate <- median(data, na.rm=TRUE)/qchisq(0.5, df)
    out$se <- NA
  } else if (method=="KS") {
    limits <- c(0.5, 100)
    out$estimate <- estLambdaKS(data, limits=limits, df=df)
    if ( abs(out$estimate-limits[1])<1e-4 || abs(out$estimate-limits[2])<1e-4 )
      warning("using method='KS' lambda too close to limits, use other method")
    out$se <- NA
  } else {
    stop("'method' should be either 'regression' or 'median'!")
  }
  
  if (plot) {
    lim <- c(0, max(data, ppoi,na.rm=TRUE))
    #       plot(ppoi,data,xlim=lim,ylim=lim,xlab="Expected",ylab="Observed", ...)
    oldmargins <- par()$mar
    par(mar=oldmargins + 0.2)
    plot(ppoi, data,
         xlab=expression("Expected " ~ chi^2),
         ylab=expression("Observed " ~ chi^2),
         ...)
    abline(a=0, b=1)
    abline(a=0, b=out$estimate, col="red")
    par(mar=oldmargins)
  }
  
  out
}

#genomic inflation factor WITHOUT pca
results = read.table("assoc_nopca.assoc.logistic", header=TRUE)
pvalues = results[, 12]
estlambda(pvalues)