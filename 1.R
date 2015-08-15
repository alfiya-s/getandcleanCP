read_dta <- function(samp) {
pths <- paste0('./', samp, '/')
a <- c('subject_', 'X_', 'y_')
pths1 <- paste0(pths, a, samp, '.txt')
dt <- lapply(pths1, scan, sep = c('', ' ', ''))
dt1 <- dt[[1]]
dt2 <- dt[[3]]
dt3 <- dt[[2]]

dt4 <- readLines('activity_labels.txt')
dt5 <- readLines('features.txt')
list(dt1, dt2, dt3, dt4, dt5)
}
dt.t <- read_dta('test')
dt.tr <- read_dta('train')
dt <- rbind(dt.t, dt.tr)