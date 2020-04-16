# Copyright (c) 2020 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#
# Contributors:
#   Red Hat, Inc. - initial API and implementation

FROM quay.io/buildah/stable:v1.14.0

ENV HOME="/home/buildah" \
    XDG_RUNTIME_DIR="/var/tmp/containers/runtime"

ADD etc/storage.conf ${HOME}/.config/containers/storage.conf
ADD etc/containers.conf ${HOME}/.config/containers/containers.conf
ADD etc/subuid /etc/subuid
ADD etc/subgid /etc/subgid

RUN mkdir /projects && \
    # Change permissions to let any arbitrary user
    for f in "${HOME}" "/etc/passwd" "/projects"; do \
      echo "Changing permissions on ${f}" && chgrp -R 0 ${f} && \
      chmod -R g+rwX ${f}; \
    done && \
    # buildah login requires writing to /run
    chgrp -R 0 /run && chmod -R g+rwX /run && \
    mkdir -p /var/tmp/containers/runtime && \
    chmod -R g+rwX /var/tmp/containers

ADD etc/entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

CMD tail -f /dev/null
