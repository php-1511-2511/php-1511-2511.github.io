#
#
# Add data read from _csv directory to site.data
#
# For each csv file <<name>> found in _csv/, this plugin adds the
# following information:
#
# * site.data.<<name>>.rows (number of rows)
# * site.data.<<name>>.cols (number of columns)
#
# * site.data.<<name>>.keys (Array containing the headers of the csv file)
# * site.data.<<name>>.content (array of arrays: content of the csv file)
# * site.data.<<name>>.content_hash (array of hashes: content of the csv file)
#
# The content is available similar to @_data@
#
# Example
#
# Suppose you have a my_table.csv file in the _csv directory,
# with the following content:
#
#  h1,h2,h3
#  a,b,c
#  1,2,3
#
 #You can build an HTML representation of the table with the following code:

 <table>
 <thead>
 <tr>
 {% for header in site.data.my_table.keys %}
   <td>{{header}}</td>
 {% endfor %}
 </tr>
 </thead>

 <tbody>
 {% for row in site.data.my_table.content %}
 <tr>
   {% for column in row %}
      <td>{{column}}</td>
   {% endfor %}
 </tr>
 {% endfor %}
 </tbody>
 </table>
 


