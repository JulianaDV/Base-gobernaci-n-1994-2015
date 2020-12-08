# ---------------------------------------------------------------------------- #
# Panel candidatos y votos elecciones gobernación Santander                    #
# (1994 - 2015)                                                                #
# Autores: Simón Caicedo y Juliana Dueñas                                      #
# Insumos tesis PHD Andrés Sampayo                                             #
# ---------------------------------------------------------------------------- #

# Directorio de trabajp
setwd("C:/Users/jdv97/Documents/Tesis Andres/Panel Nuevo")

# Paquetes necesarios
library(haven)
library(tidyverse)

# Cargando bases por periodo
Gobernadores_1994 <- read_dta("Gobernadores_1994.dta")
Gobernadores_1997 <- read_dta("Gobernadores_1997.dta")
Gobernadores_2000 <- read_dta("Gobernadores_2000.dta")
Gobernadores_2003 <- read_dta("Gobernadores_2003.dta")
Gobernadores_2007 <- read_dta("Gobernadores_2007.dta")
Gobernadores_2011 <- read_dta("Gobernadores_2011.dta")
Gobernadores_2015 <- read_dta("Gobernadores_2015.dta")

# Renombrando variables 
Gobernadores_1994 <- rename(Gobernadores_1994, 
                            primer_apellido_suplente = primer_appellido_suplente)

# Pegamos verticalmente las bases con variables idénticas (1994-2007)
Panel_gobernadores9407 <- rbind(Gobernadores_1994, Gobernadores_1997)
Panel_gobernadores9407 <- rbind(Panel_gobernadores9407, Gobernadores_2000)
Panel_gobernadores9407 <- rbind(Panel_gobernadores9407, Gobernadores_2003)
Panel_gobernadores9407 <- rbind(Panel_gobernadores9407, Gobernadores_2007)

rm(Gobernadores_1994, Gobernadores_1997, Gobernadores_2000, 
   Gobernadores_2003, Gobernadores_2007)

# Reorganizando bases para pegarlas
Gobernadores_2011 <- Gobernadores_2011[,-c(7:17, 19:24)]
Gobernadores_2011 <- rename(Gobernadores_2011, codpartido = codigo_1)
attach(Panel_gobernadores9407)
Panel_gobernadores9407$candidato <- paste0(nombre," ", primer_apellido, " ",segundo_apellido)
Panel_gobernadores9407$candidato <- ifelse(primer_apellido == "VOTOS EN BLANCO" |
                                             primer_apellido == "VOTOS NULOS", primer_apellido,
                                           candidato)

Panel_gobernadores9407 <- Panel_gobernadores9407[, -c(2, 7:11, 13:16)]
Panel_gobernadores9407$departamento <- NA
Panel_gobernadores9407 <- Panel_gobernadores9407[,c(1,2,8,3,4,7,6,5)]

Gobernadores_2011$codep <- NA
Gobernadores_2011 <- Gobernadores_2011[,c(1,8,3,2,4,5:7)]

# Pegando información 2011
Panel_gobernadores9407 <- rbind(Panel_gobernadores9407, Gobernadores_2011)

# FALTA 2015, REVISAR VARIABLES PARA HACER EL rbind() NO SÉ SI TENGAS UN MÉTODO MEJOR
# BTW ASÍ LO SÉ HACER YO GG


#                I   L O V E   Y O U   S I M O N C I T O                     #
