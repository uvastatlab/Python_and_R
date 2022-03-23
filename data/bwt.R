# birth weight data
# Risk Factors Associated with Low Infant Birth Weight
library(MASS)
# ?birthwt
data("birthwt")
bwt <- with(birthwt, {
  race <- factor(race, labels = c("white", "black", "other"))
  ptd <- factor(ifelse(ptl > 0, 1, 0))
  ftv <- factor(ftv)
  levels(ftv)[-(1:2)] <- "2+"
  data.frame(low = low, age, lwt, race, 
             smoke = factor(smoke),
             ptd, ht = factor(ht), ui = factor(ui), ftv)
})
# write.csv(bwt, file = "bwt.csv", row.names = FALSE)
saveRDS(bwt, file = "bwt.Rds")
