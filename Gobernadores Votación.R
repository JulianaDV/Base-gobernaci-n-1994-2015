#======================================#
#       Democracía en Santander        # 
#       Andrés Sampayo Navarro         #
#======================================#

# Librerías a usar
library(tidyverse)

if(Sys.getenv("USERNAME")=="simnc"){
  
  setwd("C:/Users/simnc/Desktop/Trabajo Andrés")
  
} else if(Sys.getenv("USERNAME")=="jdv97"){
  
  setwd("C:/Users/jdv97/Documents/Tesis Andres/Panel Nuevo")
  
}


# Leer datos con votaciones
Gob<-read.csv("Histórico votaciones 1994-2015.csv", encoding = "UTF-8")


# Remover columnas no útiles y dejar departamento de Santander únicamente


# Limpieza base de datos
colnames(Gob)<-c("Año", "codep", "Departamento", "codmpio", "Municipio", "Candidato", "Votos", "codpartido")

# % de votos ganador municipio en cada periodo electoral
VotosCandidatos<-Gob %>% 
  group_by(Año, Candidato) %>% 
  filter(codmpio != 99, Candidato != "Votos nulos", 
         Candidato != "VOTOS NULOS", Candidato != "Votos no marcados", 
         Candidato != "TARJETAS NO MARCADOS",
         Candidato != " VOTOS NULOS ", Candidato != " TARJETAS NO MARCADOS ") %>% 
  mutate(TotalVotosDpto = sum(Votos, na.rm = T)) %>% 
  select(Año, Candidato, TotalVotosDpto) %>% 
  distinct(Candidato, .keep_all = T)



VotosGanador<-VotosCandidatos %>% 
  group_by(Año) %>% 
  summarize(max(TotalVotosDpto))

colnames(VotosGanador)<-c("Año", "TotalVotosDpto")

GanadorAño<-left_join(VotosGanador, VotosCandidatos, by=c("Año", "TotalVotosDpto"))

GanadorAño$Indicador<-1

Gob2<-left_join(Gob, GanadorAño, by=c("Año", "Candidato")) %>% 
  filter(Indicador==1, codmpio != 99) 


VotosMunicipio <- Gob %>% 
  group_by(Año, Municipio) %>% 
  filter(codmpio != 99) %>% 
  summarize(VotosTotalesMun = sum(Votos))



GobernacionFinal<-left_join(Gob2, VotosMunicipio) %>% 
  select(Año, Municipio, codmpio, Candidato, Votos, VotosTotalesMun) %>% 
  rename(`Votos del Ganador` = Votos, `Votos Totales del Municipio`=VotosTotalesMun) %>% 
  mutate(`% Votos Ganador` = round((`Votos del Ganador`/`Votos Totales del Municipio`)*100, 1), 
         `% Votos Oposición` = round(100-`% Votos Ganador`, 1))


rm(GanadorAño, Gob, Gob2, VotosCandidatos, VotosGanador, VotosMunicipio)


PromediosEtapa1<-GobernacionFinal %>% 
  group_by(Municipio) %>%
  filter(Año <=2003) %>% 
  summarize(`Competencia Electoral - Etapa 1`=round(mean(`% Votos Oposición`, na.rm = T), 1))


PromediosEtapa2 <- GobernacionFinal %>% 
  group_by(Municipio) %>%
  filter(Año > 2003) %>% 
  summarize(`Competencia Electoral - Etapa 2`=round(mean(`% Votos Oposición`, na.rm = T), 1))


Promedios<-left_join(PromediosEtapa1, PromediosEtapa2)

rm(PromediosEtapa1, PromediosEtapa2)  


library(writexl)

write_xlsx(Promedios, "Promedios Gobernación Santander.xlsx")
write_xlsx(GobernacionFinal, "Gobernación Santander Democracia 1994-2015.xlsx")

