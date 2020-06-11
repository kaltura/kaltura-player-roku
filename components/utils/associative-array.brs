'
'   associative-array.brs
'
'
function AssociativeArrayUtil() as Object

    util = {

        isArray: function(arr) as Boolean
            return type(arr) = "roAssociativeArray"
        end function

        merge: function(arrA as object, arrB as object) as object
          if not m.isArray(arrA) = true then return arrA
          if not m.isArray(arrB) = true then return arrA

           for each item in arrB.Items()
              If (not arrA.DoesExist(item.key) or arrA[item.key] = Invalid) and item.value <> Invalid
                arrA[item.key] = item.value
              End If
          end for

          return arrA
        end Function

        mergeDeep: function(target as object, source as object) as object
          if source.count() = 0 then
            return target
          end if

          if m.isArray(target) and m.isArray(source) then
            For each item in source.Items()
              If m.isArray(item.value) = true then
                if not target.DoesExist(item.key)
                    target.AddReplace(item.key, source[item.key])
                else
                    m.mergeDeep(target[item.key], source[item.key])
                endif
              else
                 tmp = {}
                 tmp.AddReplace(item.key, item.value)
                 target = m.merge(target,tmp)
              end If
            End For
          end if
          return target

        end function

    }

    return util

end function
