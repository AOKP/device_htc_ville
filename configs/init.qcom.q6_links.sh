#!/system/bin/sh
# Copyright (c) 2011, Code Aurora Forum. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#     * Neither the name of Code Aurora Forum, Inc. nor the names of its
#       contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
# ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#

# No path is set up at this point so we have to do it here.
PATH=/sbin:/system/sbin:/system/bin:/system/xbin
export PATH

# Check for images and set up symlinks
cd /firmware_q6

# Get the list of files in /firmware
# for which sym links have to be created

fwfiles=`ls q6*`

# Check if the links with similar names
# have been created in /system/etc/firmware

cd /system/etc/firmware
linksNeeded=0

# For everyfile in fwfiles check if
# the corresponding file exists
for fwfile in $fwfiles; do

   # if (condition) does not seem to work
   # with the android shell. Therefore
   # make do with case statements instead.
   # if a file named $fwfile is present
   # no need to create links. If the file
   # with the name $fwfile is not present
   # need to create links.

   case `ls $fwfile` in
      $fwfile)
         continue;;
      *)
         # file with $fwfile does not exist
         # need to create links
         linksNeeded=1
         break;;
   esac

done

# if links are needed mount the FS as read write
case $linksNeeded in
   1)
      cd /firmware_q6
      mount -t ext4 -o remount,rw,barrier=0 emmc@system /system

      case `ls q6.mdt 2>/dev/null` in
         q6.mdt)
            for imgfile in q6*; do
               ln -s /firmware_q6/$imgfile /system/etc/firmware/$imgfile 2>/dev/null
            done
            break;;
         *)
            log -p w -t PIL 8960 device but no q6 image found;;
      esac

      #remount file system as read only
      mount -t ext4 -o remount,ro,barrier=0 emmc@system /system
      break;;

   *)
      # Nothing to do. No links needed
      break;;
esac

cd /


