<master>
<property name="title"> @title@ </property>
<property name="context"> @context@ </property>

@cnsi_context_bar;noquote@

<!--pass parameters-->
<include src="/packages/ctrl-resources/www/panels/room-search-results" 
name=@name@ 
capacity=@capacity@ 
location=@location@ 
add_services=@add_services@ 
all_day_p=@all_day_p@ 
all_day_date_list=@all_day_date_list@ 
to_date_list=@to_date_list@ 
from_date_list=@from_date_list@
eq=@eq@ 
current_page=@current_page@ 
row_num=@row_num@ 
paginate_p=@paginate_p@ 
max_dbrows=@max_dbrows@ 
max_returnresults=@max_returnresults@>
