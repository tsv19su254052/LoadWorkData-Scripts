declare @x xml  
set @x='<ManuInstructions ProductModelID="1" ProductModelName="SomeBike" >  
			<Location LocationID="L1" >  
			  <Step>Manu step 1 at Loc 1</Step>  
			  <Step>Manu step 2 at Loc 1</Step>  
			  <Step>Manu step 3 at Loc 1</Step>  
			</Location>  
			<Location LocationID="L2" >  
			  <Step>Manu step 1 at Loc 2</Step>  
			  <Step>Manu step 2 at Loc 2</Step>  
			  <Step>Manu step 3 at Loc 2</Step>  
			</Location>  
		</ManuInstructions>'  
SELECT @x.query('  
   for $step in /ManuInstructions/Location[1]/Step  
   return string($step)  
')  
GO
