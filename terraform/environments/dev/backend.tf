terraform {
  backend "gcs" {
    bucket = "lunar-works-316500-tfstate"
    prefix = "activity-2a/dev"
  }
}
