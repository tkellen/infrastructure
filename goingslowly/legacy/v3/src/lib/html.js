import hyperx from 'hyperx';
import virtualDom from 'virtual-dom';

export const tmpl = hyperx(virtualDom.h);
export const vdom = virtualDom.create;
