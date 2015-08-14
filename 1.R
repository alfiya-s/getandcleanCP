read_dta <- function(samp) {
pths <- paste0('./', samp, '/')
a <- c('subject_', 'X_', 'y_')
pths1 <- paste0(pths, a, samp, '.txt')
dt1 <- lapply(pths1, scan, sep = c('', ' ', ' '))
dt1 <- do.call(cbind, dt1)

a <- c('x', 'y', 'z')
b <- c('body_acc_', 'body_gyro_', 'total_acc_')
c <- expand.grid(b, a)
pths2 <- paste0(pths, 'Inertial Signals/', c[, 1], c[, 2], '_', samp, '.txt')

dt2 <- lapply(pths2, scan, sep = c('', ' ', ' '))
dt2 <- do.call(cbind, dt2)
dt <- data.frame(dt1, dt2)
names(dt)[4:12] <- paste0(c[, 1], c[, 2])
names(dt)[1:3] <- substr(a, 1, nchar(a)-1)
dt
}
dt.t <- read_dta('test')
dt.tr <- read_dta('train')
dt <- rbind(dt.t, dt.tr) 
as.numeric(dt$x)
head