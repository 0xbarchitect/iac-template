terraform {
	backend "remote" {
		organization = "darenft"
		workspaces {			
			prefix = "gcp-memstore-"
		}
	}
}