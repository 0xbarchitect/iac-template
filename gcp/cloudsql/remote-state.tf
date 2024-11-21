terraform {
	backend "remote" {
		organization = "darenft"
		workspaces {			
			prefix = "gcpsql-"
		}
	}
}
