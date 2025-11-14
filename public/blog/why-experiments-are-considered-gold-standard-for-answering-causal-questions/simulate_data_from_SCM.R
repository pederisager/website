
# Simulate data from athletic performance SCM

# --- SCM simulation for 100m sprint performance -----------------------------

set.seed(42)
n <- 3000

# Parameters (college/club cohort defaults)
p_male      <- 0.50        # Pr(gender == male)
sigma_lmm   <- 3.0         # kg, unmeasured influence on lmm
sigma_time  <- 400.0       # ms, unmeasured influence on time
sigma_bioaa <- 10.0        # VAS points, unmeasured influence on bioaa

# LMM structure
lmm_intercept_f  <- 20      # mean female muscle mass (kg)
lmm_male_shift   <- 10      # male - female difference (kg)

# Time structure (ms)
time_intercept   <- 13500   # baseline ms
beta_gender_time <- -500    # ms (male = 1, female = 0)
beta_lmm_time    <- -25     # ms per kg

# Belief (bioaa) structure
bioaa_intercept    <- 50
beta_gender_bioaa  <- 3
beta_lmm_bioaa     <- 0.6
beta_time_bioaa    <- -0.010   # per ms relative to 12,000 ms
time_center_ms     <- 12000

# --- Exogenous variables -----------------------------------------------------
gender <- rbinom(n, size = 1, prob = p_male)           # 1 = male, 0 = female
U_lmm  <- rnorm(n, mean = 0, sd = sigma_lmm)
U_time <- rnorm(n, mean = 0, sd = sigma_time)
U_bio  <- rnorm(n, mean = 0, sd = sigma_bioaa)

# --- Structural equations ----------------------------------------------------
# 1) Lean muscle mass (kg)
lmm <- lmm_intercept_f + lmm_male_shift * gender + U_lmm
# Optional floor to avoid unrealistic small values:
# lmm <- pmax(lmm, 12)

# 2) 100m time (ms)
time_ms <- time_intercept + beta_gender_time * gender + beta_lmm_time * lmm + U_time

# 3) Belief in own athletic ability (VAS 1???100)
bioaa_star <- bioaa_intercept +
  beta_gender_bioaa * gender +
  beta_lmm_bioaa * lmm +
  beta_time_bioaa * (time_ms - time_center_ms) +
  U_bio

bioaa <- pmin(100, pmax(1, bioaa_star))  # clip to [1, 100]

# --- Output dataset ----------------------------------------------------------
sim <- data.frame(
  #gender_num = gender,
  gender     = factor(ifelse(gender == 1, "male", "female"), levels = c("female", "male")),
  lmm_kg     = lmm,
  #time_ms    = time_ms,
  time_s     = time_ms / 1000,
  bioaa_vas  = bioaa
)

# --- Save dataset ----------------------------------------------------------

write.csv(sim, "sprinttime_performance_data.csv", sep = ",", row.names = FALSE, col.names = TRUE)
