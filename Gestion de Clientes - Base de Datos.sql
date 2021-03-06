CREATE DATABASE CONCESIONARIO

USE CONCESIONARIO GO

CREATE TABLE Concesionarios(
IdConcesionario int,
Descripcion varchar (50),
Primary key (IdConcesionario))
;

CREATE TABLE EquiSeries(
IdEquiSerie int,
Descripcion varchar (50),
Primary key (IdEquiSerie)
)
;

CREATE TABLE Extras(
IdExtra int,
Descripcion varchar (50),
Primary key (IdExtra)
)
;

CREATE TABLE Vehiculos(
IdVehiculo int,
Marca varchar (50),
Modelo varchar (50),
Anio smallint,
Precio decimal (10,2),
Cilindrada decimal (10,2),
IdEquiSerie int,
IdExtra int,
IdConcesionario int,
tipo nchar (20),
Primary key (IdVehiculo)
)
;

CREATE TABLE Vendedores(
IdVendedor int,
Nombre varchar (50),
Concesionario int,
Comision decimal(10,2),
Primary key (IdVendedor)
)
;
CREATE TABLE VentasEncabezado(
NumeroDoc int,
IdVendedor int,
IdVehiculo int,
IdConcesionario int,
Fecha datetime,
Total decimal(10,2),
TipoPago smallint,
Primary key (NumeroDoc)
)
;

Create view vwEjemploVendedorUMG
as
select a.IdVendedor, d.Nombre, b.Marca, c.Descripcion, a.Total,(a.Total*(d.Comision/100))[Comision],
case
when a.TipoPago = 1 then 'Credito' else 'Contado'
End [Tipo de Pago]
from VentasEncabezado a
inner join Vehiculos b on
a.IdVehiculo=b.IdVehiculo
inner join Concesionarios c on
a.IdConcesionario=c.IdConcesionario
inner join  Vendedores d on
a.IdVendedor=d.IdVendedor
where CONVERT(varchar(10), a.Fecha,103) between '01/08/2016' and '31/12/2016'
and a.Total>8000
go


select * from  vwEjemploVendedorUMG
order by IdVendedor;

--crear vista que desglose el listado de trabajadores que se tienen  en  cada uno de los concesionarios de manera agrupada, indicar
--cual de los mismos es el que mayo ventas realiaza  tomando una base inicial de $.20,000.00, asi mismo cual es el que mas comisiones a obtenido
--los  ultimos cinco a�os de los  50 concesionarios agrupar por codigo de vendedor

create view VwComisionesVendedoresPorConsecionarios
as
select a.IdVendedor, a.Nombre, c.Descripcion, (b.Total*(a.Comision/100))[Comision] --Palabra reservada [Comision]
from Vendedores a
inner join VentasEncabezado b
on a.IdVendedor=b.IdVendedor
inner join Concesionarios c
on b.IdConcesionario=c.IdConcesionario
where year(b.fecha) > year(2016) - 5
group by a.IdVendedor, a.Nombre, c.Descripcion, (b.Total*(a.Comision/100))--[Comision]
go

select * from VwComisionesVendedoresPorConsecionarios
order by Comision desc

--crear una vista donde  se desglose por a�o la cantidad de vehiculos vendidos los ultimos 8 a�os
--se debe de agrupar por tipo de vehiculo si es Sedan, Camioneta o Pick Up y por el tipo de marca 
--(Audi, BMW, Mercedez Benz, Volve, Dodge, Nissan y Toyota) se debe de mostrar de manera agrupada por a�o la 
--cantidad de vehiculos vendidos y dar una vision clara del a�o que mejor ventas se tuvieron, esto debe de ser dentro de 
--los 50 concesionarios que posee la empresa, agrupar por concecionario y ordenar por tipo de vehiculo de manera ascendente

create view VwAutomovilesVendidosUltimos8A�os
as
select year(a.Fecha)[A�o], c.Descripcion [Consecionario], v.Modelo [Tipo], v.Marca, count(a.IdVehiculo)[Cantidad]	
from VentasEncabezado a
inner join Vehiculos v
on a.IdVehiculo=v.IdVehiculo
inner join Concesionarios c
on v.IdConcesionario=c.IdConcesionario
where year(a.fecha) > year(2019) - 8
group by a.Fecha, c.Descripcion, v.Modelo, v.Marca
go

select * from VwAutomovilesVendidosUltimos8A�os
order by Tipo asc


Select * from  Concesionarios;
Select * from EquiSeries;
Select * from  Extras;
Select * from Vehiculos;
Select * from VentasEncabezado;


--+ Crear una vista que muestre la cantidad de vehiculos que hay en cada concesionario tomando en cuenta--
---que se tienen  10 concesionarios que se desean  desplegar, debe de listar cada uno de ellos y luego indicar la cantidad
--de vehiculos que se tienen iniciando sobre las marcas, como BMW, Toyota, Audi y Mercedez y Volvo, agrupar por tipo de vehiculo
-- o por concesionario, ordenar de forma descendente, colocar que vendedor tiene asignada cada linea de vehiculo para su venta+--
create view VwCantidadVehiculosConcesionarioAsignadoCloiente
as
select  c.Descripcion, COUNT(v.IdVehiculo)[Cantidad], v.Marca, v.Modelo as Tipo, n.Nombre
from Concesionarios c
inner join Vehiculos v
on c.IdConcesionario=v.IdConcesionario
inner join VentasEncabezado e
on e.IdConcesionario=c.IdConcesionario
inner join Vendedores n
on n.IdVendedor=e.IdVendedor
group by n.Nombre, v.Modelo, c.Descripcion, v.IdVehiculo, v.Marca
go

select * from VwCantidadVehiculosConcesionarioAsignadoCloiente
order by Tipo desc

-- Crear una vista donde se desglose por a�o la cantidad de veh�culos vendios los �ltimos 22 a�os,
-- se debe agrupar por tipo de veh�culo si es Sedan, Camioneta o Pick-up y por el tipo de marca (Audi, BMW, Mercedes Benz,
-- Volvo, Dodge, Nissan, Toyota y Mazda) esto se deb de mostrar de manera agrupada por a�o la cantidad
-- de veh�culos vendidos y dar una visi�n clara del a�o que mejor ventas se tuvieron y cu�l fue la marca m�s vendida,
-- esto debe ser dentro de los 10 co
select v.Modelo [Tipo_Veh�culo], v.Marca[Tipo_Marca], year(a.Fecha)[A�o], count(a.IdVehiculo)[Cantidad], c.Descripcion [Consecionario]
from VentasEncabezado a
inner join Vehiculos v
on a.IdVehiculo=v.IdVehiculo
inner join Concesionarios c
on v.IdConcesionario=c.IdConcesionario
where year(a.fecha) > year(2019) - 8
group by c.Descripcion, a.Fecha, c.Descripcion, v.Modelo, v.Marca

--cesionarios que posee la empresa y que se desea deslplegar, agrupar por concesionario,
-- ordenar por tipo de veh�culo de manera ascendnete y marca.

create view VwVentasUltimos22A�os
as

go

select * from VwVentasUltimos22A�os
order by Tipo_Veh�culo asc, 
Tipo_Marca asc


-- Realizar una vista que modifique todas las fichas de los veh�culos por marca y modelo que se tienen en cada uno de 
-- los concesionarios, donde se actualicen los nombres de los nuevos due�os, el d�a que se vendio�, el veh�culo,
-- el tipo de pago y el costo del veh�culo, de igual manera modificar a qui�n se le entreg� las llaves del veh�cuo y 
-- si el veh�culo era nuevo o usado.  Ordenar por tipo de veh�culo y concesionario

select * from VentasEncabezado

create view VwModificacionFichaVehiculos
as
select v.Modelo [Tipo_Veh�culo], v.Marca[Tipo_Marca], month(a.Fecha)[Mes], count(a.IdVehiculo)[Cantidad], a.Propietario, n.Nombre[Vendedor],
case
when a.EstadoVehiculo = 1 then 'Nuevo' else 'Usado'
end [Estado_Vehiculo]
from VentasEncabezado a
inner join Vehiculos v
on a.IdVehiculo=v.IdVehiculo
inner join Vendedores n
on a.IdVendedor=n.IdVendedor
group by a.EstadoVehiculo, v.Modelo, v.Marca, a.Fecha, a.IdVehiculo, a.Propietario, n.Nombre
go
select * from  VwModificacionFichaVehiculos

select * from VwVentasUltimos22A�os
order by Tipo_Veh�culo asc, 
Tipo_Marca asc


create view Vwvendedores
as
select *from Vendedores



--CREACION DE CURSORES


-- marcas de  los automoviles
DECLARE @marca_auto AS nvarchar(25)
DECLARE MarcaAuto CURSOR FOR SELECT [Marca] FROM Vehiculos
OPEN MarcaAuto
FETCH NEXT FROM MarcaAuto INTO @marca_auto
PRINT 'Marca'
PRINT '-----'
WHILE @@fetch_status = 0
BEGIN
    PRINT @marca_auto
    FETCH NEXT FROM MarcaAuto INTO @marca_auto
END
CLOSE MarcaAuto
DEALLOCATE MarcaAuto

--Muestra datos completos de empleados

-- Declaracion de variables para el cursor
DECLARE @Id int,
@descripcion varchar(50)

-- Declaraci�n del cursor

DECLARE cConcesionarios CURSOR FOR
SELECT IdConcesionario, Descripcion FROM Concesionarios
FOR UPDATE
-- Apertura del cursor
OPEN cConcesionarios
-- Lectura de la primera fila del cursor
FETCH cConcesionarios 
INTO @Id, @descripcion
WHILE (@@FETCH_STATUS = 0 )
BEGIN
UPDATE Concesionarios
SET Descripcion = (@descripcion+'') + ' '
WHERE CURRENT OF cConcesionarios 
-- Lectura de la siguiente fila del cursor
FETCH cConcesionarios 
INTO @Id, @descripcion
END
-- Cierre del cursor
CLOSE cConcesionarios 
-- Liberar los recursos
DEALLOCATE cConcesionarios 
SELECT * FROM Concesionarios


--execute
DECLARE @sql nvarchar(1000)

SET @sql = 'SELECT

		IdConcesionario,

		Descripcion

	    FROM

		Concesionarios'

EXEC (@sql)


--Procedimiento cantidad veh�culos vendidos

go
create procedure Cantidad_Vehiculos_Vendidos
as
select  c.Descripcion, COUNT(v.IdVehiculo)[Cantidad], v.Marca, v.Modelo as Tipo, n.Nombre
from Concesionarios c
inner join Vehiculos v
on c.IdConcesionario=v.IdConcesionario
inner join VentasEncabezado e
on e.IdConcesionario=c.IdConcesionario
inner join Vendedores n
on n.IdVendedor=e.IdVendedor
group by n.Nombre, v.Modelo, c.Descripcion, v.IdVehiculo, v.Marca
order by v.modelo asc
return

exec Cantidad_Vehiculos_Vendidos


--Vista cantidad ventas autos
create view VwCantidaVentasAutos
as
select a.IdVendedor as Id_Vendedor, d.Nombre, b.Marca, c.Descripcion, a.Total,(a.Total*(d.Comision/100))[Comision],
case
when a.TipoPago = 1 then 'Credito' else 'Contado'
End [Tipo de Pago]
from VentasEncabezado a
inner join Vehiculos b on
a.IdVehiculo=b.IdVehiculo
inner join Concesionarios c on
a.IdConcesionario=c.IdConcesionario
inner join  Vendedores d on
a.IdVendedor=d.IdVendedor
where CONVERT(varchar(10), a.Fecha,103) between '01/08/2017' and '31/12/2018'
and (a.Total*(d.Comision/100))>12000
group by a.IdVendedor, d.Nombre, b.Marca, c.Descripcion, a.Total,(a.Total*(d.Comision/100)), a.TipoPago
go

select * from VwCantidaVentasAutos
order by Id_Vendedor asc


--Vista automas vendidos ultimos 10 a�os
create view VwVendidos10Anios
as
select v.Modelo [Tipo_Veh�culo], v.Marca[Tipo_Marca], year(a.Fecha)[A�o], count(a.IdVehiculo)[Cantidad], c.Descripcion [Consecionario]
from VentasEncabezado a
inner join Vehiculos v
on a.IdVehiculo=v.IdVehiculo
inner join Concesionarios c
on v.IdConcesionario=c.IdConcesionario
where year(a.fecha) > year(2019) - 10
group by c.Descripcion, a.Fecha, c.Descripcion, v.Modelo, v.Marca
go

select * from VwVendidos10Anios
order by Tipo_Marca


-- Cursor: Listado cada uno de los trabajadores de un concesionario
DECLARE @marca_auto AS nvarchar(25)
DECLARE MarcaAuto CURSOR FOR SELECT D.Nombre, V.Marca FROM VentasEncabezado E 
inner join Vehiculos V 
ON E.IdVehiculo=V.IdVehiculo
inner join Vendedores D
ON E.IdVendedor=D.IdVendedor
OPEN MarcaAuto
FETCH NEXT FROM MarcaAuto INTO @marca_auto
PRINT 'Vendedor     Marca'
PRINT '-----'
WHILE @@fetch_status = 0
BEGIN
    PRINT @marca_auto
    FETCH NEXT FROM MarcaAuto INTO @Marca_auto
END
CLOSE MarcaAuto
DEALLOCATE MarcaAuto


DECLARE @sql nvarchar(1000)

SELECT E.IdVendedor, V.Nombre, D.Marca FROM  VentasEncabezado E
inner join Vendedores V
on E.IdVendedor= V.IdVendedor
inner join Vehiculos D
on E.IdVehiculo=D.IdVehiculo
where D.Marca='VMW' 


--Procedimiento de cantidad de veh�culos por concesionario
go
create view Cantidad_Vehiculos_Cada_Concesionario
as
select  c.Descripcion, COUNT(v.IdVehiculo)[Cantidad], v.Marca, v.Modelo as Tipo
from Concesionarios c
inner join Vehiculos v
on c.IdConcesionario=v.IdConcesionario
inner join VentasEncabezado e
on e.IdConcesionario=c.IdConcesionario
inner join Vendedores n
on n.IdVendedor=e.IdVendedor
group by v.tipo, v.Modelo, c.Descripcion, v.IdVehiculo, v.Marca
go

select * from Cantidad_Vehiculos_Cada_Concesionario
order by Descripcion


--Vista de cantidad de ventas de autos por vendedor
create procedure CantidaVentasAutosVendedor
as
select a.IdVendedor as Id_Vendedor, d.Nombre, b.Marca, c.Descripcion, a.Total,(a.Total*(d.Comision/100))[Comision],
case
when a.TipoPago = 1 then 'Credito' else 'Contado'
End [Tipo de Pago]
from VentasEncabezado a
inner join Vehiculos b on
a.IdVehiculo=b.IdVehiculo
inner join Concesionarios c on
a.IdConcesionario=c.IdConcesionario
inner join  Vendedores d on
a.IdVendedor=d.IdVendedor
where CONVERT(varchar(10), a.Fecha,103) between '01/08/2017' and '31/12/2019'
and (a.Total*(d.Comision/100))>5000
group by a.IdVendedor, b.Modelo, d.Nombre, b.Marca, c.Descripcion, a.Total,(a.Total*(d.Comision/100)), a.TipoPago
order by b.Modelo
return

exec CantidaVentasAutosVendedor


--Vista veh�culos vendidos en los �ltimos a�os
create view VwVendidos30Anios
as
select v.Modelo [Tipo_Veh�culo], v.Marca[Tipo_Marca], year(a.Fecha)[A�o], count(a.IdVehiculo)[Cantidad], c.Descripcion [Consecionario]
from VentasEncabezado a
inner join Vehiculos v
on a.IdVehiculo=v.IdVehiculo
inner join Concesionarios c
on v.IdConcesionario=c.IdConcesionario
where year(a.fecha) > year(2019) - 10
group by c.Descripcion, a.Fecha, c.Descripcion, v.Modelo, v.Marca
go

select * from VwVendidos30Anios
order by Tipo_Marca


-- Cursor: Listado cada uno de los trabajadores de un concesionario
-- Crear las variables para que el cursos guarde los datos
declare @VendedoresId int
declare @VendedoresNombre varchar(50)
declare @VendedoresConcesionario int
declare @VendedoresComision decimal(10,2)

-- Crear el cursor
declare ListadoVendedores Cursor scroll
for select * from Vendedores;

--abrir
Open ListadoVendedores
fetch next from ListadoVendedores into  @VendedoresId, @VendedoresNombre, @VendedoresConcesionario, @VendedoresComision

CLOSE ListadoVendedores
DEALLOCATE ListadoVendedores

DECLARE vend_cursor CURSOR  
    FOR SELECT * FROM Vendedores V
	inner join VentasEncabezado  C on
	V.IdVendedor=C.IdVendedor
OPEN vend_cursor  
FETCH NEXT FROM vend_cursor; 
CLOSE vend_cursor
DEALLOCATE vend_cursor



SELECT E.IdVendedor, V.Nombre, D.Marca FROM  VentasEncabezado E
inner join Vendedores V
on E.IdVendedor= V.IdVendedor
inner join Vehiculos D
on E.IdVehiculo=D.IdVehiculo
where D.Marca='VMW' 


DECLARE @ID_VENDEDOR char(8), @NOMBRE char(8), @CONSECIONARIO char(8), @SUS_VENTAS char(8), @MARCA CHAR(8) --- Para mostrar el contenido del cursor
declare Vendedores01 
cursor FOR select b.Fecha, a.Nombre, c.Descripcion[Consecionario], b.Total[Sus_Ventas],v.Marca
from dbo.Vendedores a inner join dbo.VentasEncabezado b
    on a.IdVendedor = b.IdVendedor  
inner join dbo.Concesionarios c
    on b.IdConcesionario = c.IdConcesionario
inner join Vehiculos v on v.IdVehiculo = b.IdVehiculo 
where year(b.Fecha) > year(2019)-4 
and b.Total > '1000'
and v.Marca = 'TOYOTA' 
group by a.IdVendedor,a.Nombre,c.Descripcion,b.Total,v.Marca,b.Fecha
order by a.IdVendedor
open Vendedores01   --abrimos el cursor

FETCH Vendedores01  INTO @ID_VENDEDOR, @NOMBRE, @CONSECIONARIO, @SUS_VENTAS, @MARCA
--Agrendo el contenido
		Print'************************************************'
		WHILE @@FETCH_STATUS = 0  --Mientras el estado de todas la filas sea igual a 0.
		BEGIN			  
			  PRINT +'||  '+@ID_VENDEDOR + SPACE(5)+@NOMBRE+SPACE(5)+@CONSECIONARIO+SPACE(5)+@SUS_VENTAS+SPACE(5)+@MARCA+'||'			  
			  FETCH Vendedores01 INTO @ID_VENDEDOR, @NOMBRE, @CONSECIONARIO, @SUS_VENTAS,@MARCA			  
		END
		PRINT '*************************************************'
CLOSE Vendedores01  
DEALLOCATE  Vendedores01  