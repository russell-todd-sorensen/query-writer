<pre>
namespace eval $object {

    ad_proc -public new {
@optional_attributes@@required_attributes@
    } {
      Creates @object@ 
      Returns new object_id or empty string on failure.
      @author Query-Writer
      @cvs-id $Id: tcl-api-create.adp,v 1.1 2003/07/28 21:54:31 tom Exp $
    } {

      
    }

    ad_proc -public update {
@set_attributes@@required_keys@
    } {
      Updates @object@
      @author Query-Writer
      @cvs-id $Id: tcl-api-create.adp,v 1.1 2003/07/28 21:54:31 tom Exp $
    } {


    }
}
</pre>
