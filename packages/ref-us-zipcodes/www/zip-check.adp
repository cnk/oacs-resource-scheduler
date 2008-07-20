<master src="master">

<property name="title">Zip Code Check</property>

<table border="0" cellspacing="0" cellpadding="0" width="100%" bgcolor="#FFFFFF">
 <tr>
  <td>
   <if @ref_zipcode@ not nil>
    <if @zipcodes:rowcount@ eq 0>
     The Zip Code does not exist
    </if>
    <else>
    <multiple name="zipcodes">
    <ul>
    <li>Maquest Zipcode: <a href="http://www.mapquest.com/maps/map.adp?country=US&zipcode=@ref_zipcode@" target="_blank">@ref_zipcode@</a>
    <li>Maquest Lat/Long: <a href="http://www.mapquest.com/maps/map.adp?latlongtype=decimal&latitude=@zipcodes.latitude@&longitude=@zipcodes.longitude@" target="_blank">Latitude: @zipcodes.latitude@, Longitude: @zipcodes.longitude@</a>
    </ul>
    <br>
    </multiple>
    </else>
   </if>

   <form action="zip-check" method="post">
   <input type="text" name="ref_zipcode" value="@ref_zipcode@" size="5" maxlength="5">
   <input type="submit" value="search">
   </form>
  </td>
 </tr>
</table>
