function byId(id) {
return document.getElementById(id);
}

function vote(node) {
var v = node.id.split(/_/); // {'up', '123'}
