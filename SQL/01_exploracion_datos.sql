
-- PROYECTO: ANALISIS DE EMBUDO Y RETENCION

-- MERCADOLIBRE

-- Archivo 01: Exploración de datos

-- 1. Explorar tabla mercadolibre_funnel

SELECT *
FROM mercadolibre_funnel
LIMIT 5;


-- 2. Explorar tabla mercadolibre_retention

SELECT *
FROM mercadolibre_retention
LIMIT 5;


-- 3. Identificar los eventos registrados

SELECT DISTINCT 
       event_name
FROM mercadolibre_funnel
ORDER BY event_name;
