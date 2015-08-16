# Here I create the function for getting data from folders 'Test' and 'Train'
# It returns list of data frames (they have different length).
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

#Get the data
dt.t <- read_dta('test')
dt.tr <- read_dta('train')

#Join test and train subsets
dt.all <- mapply(c, x = dt.t, y = dt.tr, SIMPLIFY = F)
rm(dt.t, dt.tr)

# Add labels from files, drop rownames
dt.all$activity_labels <- readLines('activity_labels.txt')
dt.all$features <- readLines('features.txt')
dt.all <- lapply(dt.all, unname)

#Merge data frames with their labels
## First, create data frame with all variables
dt.temp1 <- data.frame(cbind(dt.all[[1]], dt.all[[3]]))
colnames(dt.temp1) <- c('subject', 'act')
dt.temp1 <- cbind(measure = dt.all[[2]], dt.temp1, meas.dscr = dt.all[[5]])

## Second, merge labels
dt.temp2 <- data.frame(do.call(rbind, strsplit(dt.all[[4]], ' ')))
dt.temp2[, 1] <- as.numeric(dt.temp2[, 1])
colnames(dt.temp2) <- c('act.lbl', 'Activity')
row.names(dt.temp2) <- NULL
dt.all <- merge(dt.temp1, dt.temp2, by.x = 'act', by.y = 'act.lbl', all.x = TRUE)
dt.all$act <- NULL
rm(dt.temp1, dt.temp2)

# Subset only rows with Mean and Standard Deviation.
dt.all <- dt.all[grep('mean\\(\\)|std\\(\\)', dt.all$meas.dscr), ]

# Add descriptive names for activities
dt.all$Activity<- as.factor(dt.all$Activity)
dt.all$meas.dscr <- as.character(dt.all$meas.dscr)
levels(dt.all$Activity) <- c('Laying down',
                                'Sitting',
                                'Standing',
                                'Walking',
                                'Walking (downstairs)',
                                'Walking (upstairs)')

# Remove unnessessary symbols from variables 
dt.all$meas.dscr <- gsub('\\d+', '', dt.all$meas.dscr)
dt.all$meas.dscr <- gsub(' ', '', dt.all$meas.dscr)

# Split variable names to obtain column indicating Mean and Standard deviation
# and then concatenate again.
dt.temp <- data.frame(do.call(rbind, strsplit(dt.all$meas.dscr, '-')))
dt.temp$X3 <- as.character(dt.temp$X3)
dt.temp[!(dt.temp$X3 %in% c('X', 'Y', 'Z')), 'X3'] <- ''
dt.all$metric <- dt.temp$X2
dt.all$meas.dscr <- paste(dt.temp$X1, dt.temp$X3, sep = ' ')

# Reshape data to wide format
dt.all <- reshape(dt.all, 
             timevar = "metric",
             idvar = c("subject", "meas.dscr", "Activity"),
             direction = "wide")
colnames(dt.all) <- c('subject', 'measures.description', 'Activity', 'mean', 'sd')

# Produce summary and write to file
require('data.table')
dt.all <- data.table(dt.all)
dt.summary <- dt.all[, .(Mean = mean(mean), Sd = mean(sd)), by=list(Activity, subject)]
write.table(dt.summary, 'data.txt', row.name=FALSE)  