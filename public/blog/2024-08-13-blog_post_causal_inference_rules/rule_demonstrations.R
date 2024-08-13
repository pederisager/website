



# Rule 1
n <- 10000 
a <- rnorm(n, 0, 1)
b <- rnorm(n, 0, 1)
summary(lm(b~a))

# Rule 2
n <- 10000
a <- rnorm(n, 0, 1)
b <- a + rnorm(n, 0, 1)
summary(lm(b~a))

# Rule 3
n <- 10000
c <- rnorm(n, 0, 1)
a <- c + rnorm(n, 0, 1)
b <- c + rnorm(n, 0, 1)
summary(lm(b~a))

# Rule 4
# no code for this one

# Rule 5
n <- 10000
c <- rnorm(n, 0, 1)
a <- c + rnorm(n, 0, 1)
b <- c + rnorm(n, 0, 1)
summary(lm(scale(b)~scale(a) + scale(c)))

# Rule 6
n <- 10000
a <- rnorm(n, 0, 1)
m <- a + rnorm(n, 0, 1)
b <- m + rnorm(n, 0, 1)
summary(lm(b~a + m))

# Rule 7
n <- 10000
a <- rnorm(n, 0, 1)
b <- rnorm(n, 0, 1)
d <- a + b + rnorm(n, 0, 1)
summary(lm(b~a + d))

