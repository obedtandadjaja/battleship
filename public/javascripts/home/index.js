$(document).ready(function()
{
	$('td').click(function()
	{
		var col = $(this).closest('table').find('th').eq(this.cellIndex).attr('class');
		console.log(col);
		var row = $(this).parent().attr('class');
		swal("You clicked:", col+" : "+row, "success");
	});
});