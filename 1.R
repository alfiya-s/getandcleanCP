read_dta <- function(samp) {
pths <- paste0('./', samp, '/')
a <- c('subject_', 'X_', 'y_')
pths1 <- paste0(pths, a, samp, '.txt')
dt <- lapply(pths1, scan, sep = c('', ' ', ''))
dt1 <- dt[[1]]
dt2 <- dt[[2]]
dt3 <- dt[[3]]

dt <- list(dt1, dt2, dt3)
names(dt) <- pths1
dt
}
dt.t <- read_dta('test')
dt.tr <- read_dta('train')

dt.raw <- mapply(c, x = dt.t, y = dt.tr, SIMPLIFY = F)
rm(dt.t, dt.tr)
dt.raw$activity_labels <- readLines('activity_labels.txt')
dt.raw$features <- readLines('features.txt')
dt.raw <- lapply(dt.raw, unname)

dt.temp1 <- data.frame(cbind(dt.raw[[1]], dt.raw[[3]]))
colnames(dt.temp1) <- c('subject', 'act')
dt.temp2 <- data.frame(do.call(rbind, strsplit(dt.raw[[4]], ' ')))
dt.temp2[, 1] <- as.numeric(dt.temp2[, 1])
colnames(dt.temp2) <- c('act.lbl', 'act.dscr')
row.names(dt.temp2) <- NULL
dt.temp1 <- merge(dt.temp1, dt.temp2, by.x = 'act', by.y = 'act.lbl', all.x = TRUE)
dt.all <- cbind(meas = dt.raw[[2]], dt.temp1, meas.dscr = dt.raw[[5]])
rm(dt.temp1, dt.temp2)

dt.target <- dt.all[grep('mean()|std()', dt.all$meas.dscr), ]
rm(dt.all)