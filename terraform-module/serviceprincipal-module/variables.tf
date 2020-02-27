variable "resource-group-id" {
    description = "The Service Principal is restricted to this provided Azure Resource Group"
}

variable "application-name" {
    description = "Azure AD Application name to create for the service principal"
}

variable "password" {   
    description = "Password for the Azure AD Service Principal"
}