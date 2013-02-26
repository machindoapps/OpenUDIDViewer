OpenUDIDViewer
==============

App to display the contents of the device's Pasteboard for all 100 OpenUDID slots.

OpenUDID works by saving information to the pasteboard in 100 locations, with the slot identifiers of the form org.OpenUDID.slot.n, where 'n' is 0..99.

This app queries the Pasteboard at these locations, and outputs the contents formatted into a tableView.

This can be useful to use when debugging apps that require the use of OpenUDID, as there is no other way to see the saved information, and normal 'Pasteboard viewer' apps don't pick this up.
