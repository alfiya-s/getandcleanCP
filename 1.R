setwd("C:/Users/fifiu_000/OneDrive/Downloads/UCI HAR Dataset")
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

dt.all <- mapply(c, x = dt.t, y = dt.tr, SIMPLIFY = F)
rm(dt.t, dt.tr)
dt.all$activity_labels <- readLines('activity_labels.txt')
dt.all$features <- readLines('features.txt')
dt.all <- lapply(dt.all, unname)

dt.temp1 <- data.frame(cbind(dt.all[[1]], dt.all[[3]]))
colnames(dt.temp1) <- c('subject', 'act')
dt.temp1 <- cbind(measure = dt.all[[2]], dt.temp1, meas.dscr = dt.all[[5]])
dt.temp2 <- data.frame(do.call(rbind, strsplit(dt.all[[4]], ' ')))
dt.temp2[, 1] <- as.numeric(dt.temp2[, 1])
colnames(dt.temp2) <- c('act.lbl', 'Activity')
row.names(dt.temp2) <- NULL
dt.all <- merge(dt.temp1, dt.temp2, by.x = 'act', by.y = 'act.lbl', all.x = TRUE)
dt.all$act <- NULL
rm(dt.temp1, dt.temp2)

dt.all <- dt.all[grep('mean\\(\\)|std\\(\\)', dt.all$meas.dscr), ]
dt.all$Activity<- as.factor(dt.all$Activity)
dt.all$meas.dscr <- as.character(dt.all$meas.dscr)
levels(dt.all$Activity) <- c('Laying down',
                                'Sitting',
                                'Standing',
                                'Walking',
                                'Walking (downstairs)',
                                'Walking (upstairs)')
dt.temp <- data.frame(do.call(rbind, strsplit(dt.all$meas.dscr, '-')))
dt.all <- cbind(dt.all, dt.temp)
dt.all$X3 <- as.character(dt.all$X3)
dt.all[!(dt.all$X3 %in% c('X', 'Y', 'Z')), 'X3'] <- ''
dt.all$X1 <- gsub('\\d+', '', dt.all$X1)
dt.all$X1 <- gsub(' ', '', dt.all$X1)
dt.all$X4 <- substr(dt.all$X1, 1, 1)
dt.all$X1 <- substr(dt.all$X1, 2, nchar(dt.all$X1))
dt.all$meas.dscr <-  paste(dt.all$X1, dt.all$X4, dt.all$X3, sep = '-')
dt.all <- reshape(dt.all,  
                   dir = 'wide',
                   idvar = 'X2',
                   timevar = c('X1', 'X3'),
                   v.names = 'measure')
write.csv(levels(dt.all$X1), file = '1.csv')
eshape(DT.weekly, 
       varying = c('FALSE.','TRUE.'),
       v.names ='steps',
       timevar = 'day',
       times = c('Weekday','Weekend'))