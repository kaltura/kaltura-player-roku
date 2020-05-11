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
              If not arrA.DoesExist(item.key)
                arrA[item.key] = item.value
              End If
          end for

          return arrA

        end Function

        mergeDeep: function(target as object, source as object) as object

          tmp = {}
          if source.count() = 0 then
            return target
          end if

          if m.isArray(target) and m.isArray(source) then
            For each item in source.Items()
              If m.isArray(source[item.key]) = true then
                tmp.AddReplace(item.key,{})
                if target[item.key] = invalid then target = m.merge(target,tmp)
                m.mergeDeep(target[item.key], source[item.key])
              else
                tmp.AddReplace(item.key, item.value)
                target = m.merge(target,tmp)
              end If
            End For
          end if
          return target

        end function

        print: function(target as object,tabSpace=0)

          print m._duplicateString(" ",tabSpace) + "{"
          if target.count() = 0 then
            print m._duplicateString(" ",tabSpace) + target
          end if

          if m.isArray(target) then
            For each item in target.Items()
              If m.isArray(target[item.key]) = true then
                m.print(target[item.key], tabSpace + 2)
              else
                print m._duplicateString(" ",tabSpace + 2) + item.key ": " item.value
              end If
            End For
          end if
          print m._duplicateString(" ",tabSpace) + "}"

        end function


        _duplicateString: function(str as String, counter) as string
          retStr = ""
          For i=0 to counter step 1
            retStr += str
          End For
          return retStr
        end function

    }

    return util

end function
