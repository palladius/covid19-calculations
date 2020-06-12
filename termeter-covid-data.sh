

# prep before Termeter
#cut -d, -f 5,8-11 | tee t |  termeter --delimeter=","
# | 
#     sed 's/ /_/g' |
#     sed 's/_..:..:..//g' |
#     sed 's/,/   /g'|  
cat t  #| sed 's/,/   /g'
cat t |
    awk 'BEGIN{IFS=","; OFS="\t"; print "date","Confirmed","Deaths","Recovered"}
              {OFS="\t"; print $5, $8, $7,$8}'
#echo ciao