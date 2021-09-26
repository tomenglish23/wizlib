using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations.Schema;

namespace WizLib_Model.Models
{
    [Table("tb_Genre")]
    public class Genre
    {
        public int GenreId { get; set; }
        [Column("Name")]
        public string GenreName { get; set; }
    }
}
