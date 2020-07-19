#!/bin/bash
SERVER=(
    master.k8s.indi
    node1.k8s.indi
    node2.k8s.indi
)
:<<EOF
for file in "$@": do
    echo "Uploading ${file}"
    for server in "$SERVER": do
        echo "uploading to ${server}..."
        ssh -o PubkeyAuthentication=no ./$file f@${server}:/home/f
    done
done
echo Finish\ uploading
EOF

for server in "$SERVER"
do
    echo "uploading to ${server}..."
    scp -o PubkeyAuthentication=no ./$0 f@${server}:/home/f
done

