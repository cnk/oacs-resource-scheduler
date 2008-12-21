<master>
<property name="title">@page_title@</property>

<h1> Room Reservation </h1>


Click on one of the options to proceed: 
<div style="padding-left:30px">
<ul>
   <if @user_most_common:rowcount@ gt 0>
    <li> Rooms that you have reserved in the past. 
    <table cellspacing="10px"><tr>
         <multiple name="user_most_common">  
	     <td valign="top" align="center"> 
	     <include src="/packages/ctrl-resources/www/images-display-single-fixed" resource_id="@user_most_common.room_id@" action="display"><br>
	     <a href='@user_most_common.reserve_url@'>@user_most_common.room_name@</a></td>
         </multiple>
    </tr></table>
    </li>
   </if> 
   <if @pkg_most_common:rowcount@ gt 0>
    <li> Rooms that have been reserved the most by the other members
    <table cellspacing="10px"><tr>
         <multiple name="pkg_most_common">  
             <td valign="top" align="center">
	     <include src="/packages/ctrl-resources/www/images-display-single-fixed" resource_id="@pkg_most_common.room_id@" action="display"><br>
	     <a href='@pkg_most_common.reserve_url@'>@pkg_most_common.room_name@</a></td>
         </multiple>
    </tr></table>
    </li>
   </if> 

    <li> <a href="@search_url@">Search for a room</a></li>
    <li> <a href="@search_url2@">Search for an equipment</a></li>
    <li> <a href="view"> View your current reservations  </a> </li>
    <li> Quick Room Views: <a href='@video_url@'>Video Playback</a> | <a href='@data_projector_url@'>Data Projectors</a> |
<a href='@slide_projector_url@'>Slide Projectors</a> | <a href='@sound_url@'>Sound Systems</a> | <a href="@all_rooms@"> All Rooms </a> </li>
</ul>
<br><br>
<h2> Administration </h2>
<ul>
    <li> <a href='@admin_room_url@'>Room Administration</a></li>
    <li> <a href='@admin_resv_resource_url@'>General Equipment Administration</li>
</ul>
</div>