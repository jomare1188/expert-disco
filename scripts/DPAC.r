
###############################
#library(vcfR)
#library(adegenet)
#TRS.G100<-read.vcfR("myvcf.vcf")
#TRS.G100.genind<-vcfR2genind(TRS.G100)
#snapclust(TRS.G100.genind,k=2)
###################################
# corro snapclust.choose.k para mira que k es 

library(adegenet)
x <- read.genepop('/home/jorge/samples/denovo/DPCA/recode.gen', ncode=3L)

## calculo AIC
x.aic <- snapclust.choose.k(6, x)
plot(x.aic, type = "b", cex = 2, xlab = "k", ylab = "AIC")
points(which.min(x.aic), min(x.aic), col = "blue", pch = 20, cex = 2)
abline(v = 3, lty = 2, col = "red")

## calculo BIC
x.bic <- snapclust.choose.k(6, x, IC = BIC)
plot(x.bic, type = "b", cex = 2, xlab = "k", ylab = "BIC")
points(which.min(x.bic), min(x.bic), col = "blue", pch = 20, cex = 2)
abline(v = 3, lty = 2, col = "red")

names <- paste(c('Antioquia','Cordoba','Nariño', 'Cauca',' Nuqui'))
popNames(x)<-names 

## uso snap clust
x.clust <- snapclust(x, k=3)
x.tab <- table(pop(x), x.clust$group)
table.value(x.tab, grid = FALSE ,  col.labels = 1:24, csize = .6 )

x.dapc <- dapc(x, n.pca = 40, n.da =  3, x.clust$group)
compoplot.dapc(x.dapc, n.col=3)
#scatter(x.dapc, clab = 0.85, col = funky(24),
 #       posi.da="topleft", posi.pca = "bottomleft", scree.pca = TRUE , label =  c("P1", "P2", "C"))

myCol <- c("darkblue","orange","green")
scatter(x.dapc, posi.da = "topright",  bg="white", pch=10:10, col=myCol, label =  c("Pacifico 1", "Pacifico 2", "Caribe") )

assignplot(x.dapc)