function display(this)
    [iVerts, iEdges] = Size(this);
    
    disp(' ');
    disp([inputname(1),' = ']);
    disp(' ');

    disp(['   `Graph` object with ' num2str(iVerts) ' vertices and ' ...
          num2str(iEdges) ' edges.']);
    disp(['   Use `' inputname(1) '.ToMatrix()` to ' ...
          'see the adjacency matrix of this graph.']);
end