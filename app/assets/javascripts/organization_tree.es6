class OrganizationTree {
  
  constructor(data) {
    this.data = data; 
  }

  index() {
    var data = this.data; 
    $(function () { $('#tree').jstree({ 'core': { 'data': data } }).on( 'select_node.jstree', (node, event) =>
      {  if ( event.node.id && event.node.id !== 0 ) { window.location.href = window.location.href + "/" + event.node.id + "/edit" } } 
    ); }); 
  }
  
  show() {
    var data = this.data; 
    var updateParent = ( node ) => { 
      $("#organization_organization_id").val(node.id); 
      let link = $("a#parent_link");
      link.prop('href', link.prop("href").replace( new RegExp("\\d$"), node.id ));
      link.text( node.text );
      $("#orgModal").modal("toggle");
    } 
    
    $(function () { $('#tree').jstree({ 'core': { 'data': data } }).on( 'select_node.jstree', (node, event) =>
      {  if ( event.node.id && event.node_id !== 0 ) {  updateParent(event.node); } } 
    ); }); 
  }

}
