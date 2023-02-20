"""
#.. file:: run_DFN_transport.py
#   :synopsis: run file for dfnworks 
#   :version: 1.0
#   :solve flow and particle transport in full DFN
#.. Seonkyoo Yoon <yoonx213@umn.edu>
"""

from pydfnworks import * 

DFN = create_dfn()
DFN.make_working_directory()

""" dfnGen """
DFN.check_input()
DFN.create_network()
DFN.output_report() # generate results_output_report.pdf 
## Meshing - LaGriT: may be used to generate reduced_mesh.inp
DFN.mesh_network()

""" flow & transport """
DFN.dfn_flow()
DFN.dfn_trans()
