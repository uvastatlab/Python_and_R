# birth weight data
# Risk Factors Associated with Low Infant Birth Weight
library(MASS)
# ?birthwt
bwt <- with(birthwt, {
  race <- factor(race, labels = c("white", "black", "other"))
  ptd <- factor(ptl > 0)
  ftv <- factor(ftv)
  levels(ftv)[-(1:2)] <- "2+"
  data.frame(low = factor(low), age, lwt, race, smoke = (smoke > 0),
             ptd, ht = (ht > 0), ui = (ui > 0), ftv)
})
write.csv(bwt, file = "bwt.csv", row.names = FALSE)
saveRDS(bwt, file = "bwt.Rds")
